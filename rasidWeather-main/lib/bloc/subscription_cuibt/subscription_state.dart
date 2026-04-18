part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => <Object?>[];
}

class PurchaseInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionNotAvailable extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  const SubscriptionLoaded({
    required this.productDetails,
    required this.plans,
    required this.currentPlanNameFromBackend,
    required this.isVip,
    required this.storeAvailable,
    required this.missingProductIds,
  });

  final List<ProductDetails> productDetails;

  final List<PlanModel> plans;

  final String? currentPlanNameFromBackend;

  final bool isVip;

  final bool storeAvailable;

  final List<String> missingProductIds;

  @override
  List<Object?> get props => <Object?>[
    productDetails,
    plans,
    currentPlanNameFromBackend,
    isVip,
    storeAvailable,
    missingProductIds,
  ];
}

class SubscriptionError extends SubscriptionState {
  const SubscriptionError(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class SubscriptionRestoring extends SubscriptionState {}

class SubscriptionRestoreRequested extends SubscriptionState {}

class PurchasePending extends SubscriptionState {}

class PurchaseSuccess extends SubscriptionState {
  const PurchaseSuccess(this.purchaseDetails);

  final PurchaseDetails purchaseDetails;

  @override
  List<Object?> get props => <Object?>[purchaseDetails];
}

class PurchaseError extends SubscriptionState {
  const PurchaseError(this.error);

  final String error;

  @override
  List<Object?> get props => <Object?>[error];
}

class LoadingPurchase extends SubscriptionState {}

class LoadedPurchase extends SubscriptionState {
  const LoadedPurchase(this.result);

  final bool? result;

  @override
  List<Object?> get props => <Object?>[result ?? false];
}
