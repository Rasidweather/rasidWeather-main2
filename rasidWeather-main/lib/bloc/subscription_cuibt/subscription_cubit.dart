import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../../common/constants/strings.dart';
import '../../common/widgets/subscription_info_model.dart';
import '../../constant.dart';
import '../../data/model/base/api_response.dart';
import '../../data/model/plan_model.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/profile_repo.dart';
import '../../services/revenuecat_webhook_service.dart';
import '../../subscriptions/revenuecat_identity.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit(this.inAppPurchase, this.profileRepo)
    : super(PurchaseInitial()) {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        inAppPurchase.purchaseStream;

    print('🟢 SubscriptionCubit initialized');
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdated,
      onError: _onError,
    );
  }

  final InAppPurchase inAppPurchase;
  final ProfileRepo profileRepo;

  late final StreamSubscription<List<PurchaseDetails>> _subscription;

  ProductDetails? _selectedProduct;
  ProductDetails? get selectedProductDetails => _selectedProduct;

  bool _isFetchingPlans = false;

  final List<PurchaseDetails> _latestPurchases = <PurchaseDetails>[];

  final Set<String> _subscriptionProductIds = <String>{};

  @override
  Future<void> close() {
    print('🔴 SubscriptionCubit closed');
    _subscription.cancel();
    return super.close();
  }

  void selectProduct({required ProductDetails productDetails}) {
    print('📦 Selected product: ${productDetails.id}');
    _selectedProduct = productDetails;
    emit(state);
  }

  Future<void> fetchSubscriptions() async {
    if (_isFetchingPlans) {
      print('🟡 fetchSubscriptions skipped (already fetching)');
      return;
    }
    _isFetchingPlans = true;

    try {
      print('🔵 fetchSubscriptions started');
      _selectedProduct = null;
      emit(SubscriptionLoading());

      final bool available = await inAppPurchase.isAvailable();
      print('🛒 InAppPurchase available: $available');

      if (!available && !Platform.isAndroid) {
        emit(SubscriptionNotAvailable());
        return;
      }

      final _BackendSubscription backendSub =
          await _getBackendSubscriptionSafe();
      print(
        '🟦 Backend current plan: ${backendSub.planName} | isVip=${backendSub.isVip}',
      );

      print('🌐 Fetching plans from server...');
      final ApiResponse apiResponse = await profileRepo.getPlan();

      print('📥 getPlan STATUS: ${apiResponse.response?.statusCode}');
      print('📥 getPlan DATA: ${apiResponse.response?.data}');

      final dynamic raw = apiResponse.response?.data;
      if (raw == null || raw is! Map<String, dynamic>) {
        emit(const SubscriptionError('Invalid server response (plans)'));
        return;
      }

      final dynamic bodyRaw = raw['body'];
      if (bodyRaw == null || bodyRaw is! List) {
        emit(const SubscriptionError('Invalid plans body'));
        return;
      }

      final List<PlanModel> serverPlans = bodyRaw
          .map((x) => PlanModel.fromJson(x as Map<String, dynamic>))
          .toList();
      await profileRepo.savePlans(serverPlans);

      if (serverPlans.isEmpty) {
        emit(const SubscriptionError('No plans from server'));
        return;
      }

      print('📋 Plans from server:');
      for (final PlanModel plan in serverPlans) {
        print(
          '➡️ plan=${plan.name} | android=${plan.androidProductId} | ios=${plan.iosProductId}',
        );
      }

      final List<String> productIds = <String>[];
      for (final PlanModel plan in serverPlans) {
        final String? productId = Platform.isAndroid
            ? plan.androidProductId
            : plan.iosProductId;
        if (productId != null && productId.trim().isNotEmpty) {
          productIds.add(productId.trim());
        }
      }

      if (productIds.isEmpty) {
        emit(
          SubscriptionLoaded(
            productDetails: const <ProductDetails>[],
            plans: serverPlans.reversed.toList(),
            currentPlanNameFromBackend: backendSub.planName,
            isVip: backendSub.isVip,
            storeAvailable: false,
            missingProductIds: const <String>[],
          ),
        );
        return;
      }

      _subscriptionProductIds
        ..clear()
        ..addAll(productIds);

      print('🧾 Product IDs to query: $productIds');

      bool storeOk = false;
      List<ProductDetails> storeProducts = <ProductDetails>[];
      List<String> missingIds = <String>[];

      if (!Platform.isAndroid) {
        try {
          final ProductDetailsResponse response = await inAppPurchase
              .queryProductDetails(productIds.toSet())
              .timeout(const Duration(seconds: 45));

          if (response.error != null) {
            print('❌ queryProductDetails ERROR: ${response.error}');
          } else {
            storeProducts = response.productDetails;
            storeOk = storeProducts.isNotEmpty;
          }
        } on TimeoutException {
          print('⏱️ Store timeout while fetching product details');
        } catch (e) {
          print('❌ queryProductDetails exception: $e');
        }
      }

      List<PlanModel> uiPlans = List<PlanModel>.from(serverPlans);

      if (!Platform.isAndroid && storeOk) {
        final Set<String> returnedIds = storeProducts
            .map((ProductDetails p) => p.id)
            .toSet();

        uiPlans = serverPlans.where((PlanModel plan) {
          final String? id = Platform.isAndroid
              ? plan.androidProductId
              : plan.iosProductId;
          return id != null && id.isNotEmpty && returnedIds.contains(id);
        }).toList();

        for (final String id in productIds) {
          if (!returnedIds.contains(id)) {
            missingIds.add(id);
          }
        }

        if (uiPlans.isEmpty) {
          uiPlans = List<PlanModel>.from(serverPlans);
          missingIds = List<String>.from(productIds);
          storeOk = false;
        }
      } else if (!Platform.isAndroid) {
        missingIds = List<String>.from(productIds);
      }

      const bool hideCurrentPlan = true;
      if (hideCurrentPlan &&
          backendSub.planName != null &&
          backendSub.planName!.isNotEmpty) {
        final List<PlanModel> filtered = uiPlans.where((PlanModel p) {
          final String planName = (p.name ?? '').trim();
          return planName != backendSub.planName!.trim();
        }).toList();

        if (filtered.isNotEmpty) {
          uiPlans = filtered;
        }
      }

      final Map<String, ProductDetails> byId = <String, ProductDetails>{
        for (final ProductDetails p in storeProducts) p.id: p,
      };

      final List<ProductDetails> uiProducts = <ProductDetails>[];
      for (final PlanModel plan in uiPlans) {
        final String? id = Platform.isAndroid
            ? plan.androidProductId
            : plan.iosProductId;
        final ProductDetails? pd = (id == null) ? null : byId[id];
        if (pd != null) {
          uiProducts.add(pd);
        }
      }

      emit(
        SubscriptionLoaded(
          productDetails: uiProducts,
          plans: uiPlans.reversed.toList(),
          currentPlanNameFromBackend: backendSub.planName,
          isVip: backendSub.isVip,
          storeAvailable: storeOk,
          missingProductIds: missingIds,
        ),
      );

      print('✅ fetchSubscriptions completed');
    } catch (e) {
      print('❌ fetchSubscriptions exception: $e');
      emit(SubscriptionError(e.toString()));
    } finally {
      _isFetchingPlans = false;
    }
  }

  Future<void> restorePurchases({bool silent = false}) async {
    try {
      if (!silent) {
        emit(SubscriptionRestoring());
      }
      print('🔄 restorePurchases called...');
      await inAppPurchase.restorePurchases();
      if (!silent) {
        emit(SubscriptionRestoreRequested());
      }
      print('✅ restorePurchases requested (stream will receive restored)');
    } catch (e) {
      print('❌ restorePurchases exception: $e');
      if (!silent) {
        emit(SubscriptionError('Restore failed: $e'));
      }
    }
  }

  Future<void> _onPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    print('🟠 Purchase stream update received');
    print('🟠 Purchases count: ${purchaseDetailsList.length}');

    _mergeLatestPurchases(purchaseDetailsList);

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('-----------------------------');
      print('🧾 Product ID: ${purchaseDetails.productID}');
      print('🧾 Purchase ID: ${purchaseDetails.purchaseID}');
      print('🧾 Status: ${purchaseDetails.status}');
      print('🧾 Pending complete: ${purchaseDetails.pendingCompletePurchase}');

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print('⏳ Purchase pending');
          emit(PurchasePending());

        case PurchaseStatus.purchased:
          print('✅ Purchase successful');
          emit(PurchaseSuccess(purchaseDetails));

          try {
            final UserModel? user = await profileRepo.currentUser();
            if (user != null) {
              final List<String> entitlementIds =
                  await _entitlementIdsForProduct(purchaseDetails.productID);
              final webhookEvent = RevenueCatWebhookEvent(
                type: WebhookEventType.initialPurchase,
                appUserId: user.id ?? '',
                store: Platform.isAndroid ? 'PLAY_STORE' : 'APP_STORE',
                productId: purchaseDetails.productID,
                entitlementIds: entitlementIds,
                transactionId: purchaseDetails.purchaseID,
                originalTransactionId: purchaseDetails.purchaseID,
                purchasedAt: DateTime.now().millisecondsSinceEpoch,
              );
              await RevenueCatWebhookService.sendWebhookEvent(webhookEvent);
            }
          } catch (e) {
            print('❌ Error sending purchase webhook: $e');
          }

          try {
            await syncSubscriptionFromServer();
          } catch (_) {}

          if (purchaseDetails.pendingCompletePurchase) {
            await _completePurchase(purchaseDetails);
          }

        case PurchaseStatus.restored:
          print('🔄 Purchase restored');

          try {
            await syncSubscriptionFromServer();
          } catch (_) {}

          if (purchaseDetails.pendingCompletePurchase) {
            await _completePurchase(purchaseDetails);
          }

        case PurchaseStatus.error:
          print('❌ Purchase error: ${purchaseDetails.error}');
          emit(
            PurchaseError(purchaseDetails.error?.message ?? 'Unknown error'),
          );

        case PurchaseStatus.canceled:
          print('🚫 Purchase canceled');
          emit(const PurchaseError('Purchase canceled'));
      }
    }
  }

  void _mergeLatestPurchases(List<PurchaseDetails> incoming) {
    for (final PurchaseDetails p in incoming) {
      final int idx = _latestPurchases.indexWhere(
        (PurchaseDetails x) =>
            (x.purchaseID != null && x.purchaseID == p.purchaseID) ||
            x.productID == p.productID,
      );
      if (idx >= 0) {
        _latestPurchases[idx] = p;
      } else {
        _latestPurchases.add(p);
      }
    }
  }

  Future<List<String>> _entitlementIdsForProduct(String productId) async {
    try {
      final List<PlanModel> plans = await profileRepo.getPlans();
      for (final PlanModel plan in plans) {
        if (plan.androidProductId == productId ||
            plan.iosProductId == productId) {
          final String entitlement = plan.revenuecatEntitlement?.trim() ?? '';
          if (entitlement.isNotEmpty) {
            return <String>[entitlement];
          }
        }
      }
    } catch (e) {
      print('❌ Failed to resolve entitlement for product $productId: $e');
    }

    return <String>[entitlementID];
  }

  Future<void> _completePurchase(PurchaseDetails purchaseDetails) async {
    try {
      print('📦 completePurchase called for ${purchaseDetails.productID}');
      await inAppPurchase.completePurchase(purchaseDetails);
      print('✅ completePurchase done');
    } catch (e) {
      print('❌ completePurchase failed: $e');
    }
  }

  void _onError(Object error) {
    print('🔥 Purchase stream error: $error');
    emit(PurchaseError(error.toString()));
  }

  Future<void> initiatePurchase(ProductDetails productDetails) async {
    print('🟣 initiatePurchase for ${productDetails.id}');

    final UserModel? user = await profileRepo.currentUser();
    if (user == null) {
      emit(const PurchaseError('User not logged in'));
      return;
    }

    emit(LoadingPurchase());

    try {
      await ensureRevenueCatUser(user.id);

      PurchaseParam purchaseParam;

      if (Platform.isAndroid) {
        final PurchaseDetails? oldSub =
            _findActiveAndroidSubscriptionToChangeFrom(
              newProductId: productDetails.id,
            );

        if (oldSub != null && oldSub is GooglePlayPurchaseDetails) {
          purchaseParam = GooglePlayPurchaseParam(
            productDetails: productDetails,
            applicationUserName: user.id,
            changeSubscriptionParam: ChangeSubscriptionParam(
              oldPurchaseDetails: oldSub,
              replacementMode: ReplacementMode.withTimeProration,
            ),
          );
        } else {
          purchaseParam = GooglePlayPurchaseParam(
            productDetails: productDetails,
            applicationUserName: user.id,
          );
        }
      } else {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
          applicationUserName: user.id,
        );
      }

      final bool result = await inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      emit(LoadedPurchase(result));
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  PurchaseDetails? _findActiveAndroidSubscriptionToChangeFrom({
    required String newProductId,
  }) {
    if (_subscriptionProductIds.isEmpty) return null;

    final PurchaseDetails? active = _latestPurchases
        .cast<PurchaseDetails?>()
        .firstWhere((PurchaseDetails? p) {
          if (p == null) return false;
          final bool isKnownSubscription = _subscriptionProductIds.contains(
            p.productID,
          );
          final bool isActiveStatus =
              p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored;
          final bool isDifferentProduct = p.productID != newProductId;
          return isKnownSubscription && isActiveStatus && isDifferentProduct;
        }, orElse: () => null);

    if (active != null) {
      print('🟩 Found active subscription to change from: ${active.productID}');
    }
    return active;
  }

  Future<void> syncSubscriptionFromServer() async {
    print('🔄 Sync subscription from server');

    final ApiResponse res = await profileRepo.getMySubscriptionInfo();
    final dynamic raw = res.response?.data;

    if (raw == null || raw is! Map<String, dynamic>) return;

    final dynamic bodyRaw = raw['body'];
    if (bodyRaw == null || bodyRaw is! Map<String, dynamic>) return;

    final String backendPlanName =
        (bodyRaw['name'] ?? bodyRaw['plan_name'] ?? '').toString();

    final SubscriptionInfoModel info = SubscriptionInfoModel.fromBackendName(
      backendPlanName,
    );

    await AppStrings.setCapabilities(
      removeAds: info.removeAds,
      showAnimation: info.showAnimation,
      chatWhatsApp: info.chatWhatsApp,
      chatEmail: info.chatEmail,
      planName: info.planName,
    );

    print('✅ Applied subscription from server: ${info.planName}');
  }

  Future<_BackendSubscription> _getBackendSubscriptionSafe() async {
    try {
      final ApiResponse res = await profileRepo.getMySubscriptionInfo();
      final dynamic raw = res.response?.data;

      if (raw == null || raw is! Map<String, dynamic>) {
        return const _BackendSubscription(planName: null, isVip: false);
      }

      final dynamic bodyRaw = raw['body'];
      if (bodyRaw == null || bodyRaw is! Map<String, dynamic>) {
        return const _BackendSubscription(planName: null, isVip: false);
      }

      final String planName = (bodyRaw['name'] ?? bodyRaw['plan_name'] ?? '')
          .toString();
      final String? subscriptionStatus = bodyRaw['subscription_status']
          ?.toString();
      final bool isSubscribed = _asBool(bodyRaw['is_subscribed']) ?? false;

      final bool isVip =
          (subscriptionStatus?.toLowerCase() == 'active') || isSubscribed;

      print(
        'BACKEND VIP: status=$subscriptionStatus is_subscribed=$isSubscribed plan=$planName => isVip=$isVip',
      );

      return _BackendSubscription(
        planName: planName.trim().isEmpty ? null : planName.trim(),
        isVip: isVip,
      );
    } catch (_) {
      return const _BackendSubscription(planName: null, isVip: false);
    }
  }

  bool? _asBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    final String s = v.toString().toLowerCase();
    if (s == 'true' || s == '1') return true;
    if (s == 'false' || s == '0') return false;
    return null;
  }
}

class _BackendSubscription {
  const _BackendSubscription({required this.planName, required this.isVip});
  final String? planName;
  final bool isVip;
}
