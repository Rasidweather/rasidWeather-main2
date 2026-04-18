import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../common/constants/strings.dart';
import '../../data/model/base/api_response.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/profile_repo.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../helper/router_helper.dart';
import '../../main.dart';
import '../../src/model/singletons_data.dart';
import '../../subscriptions/revenuecat_identity.dart';

part 'profile_state.dart';

class ProfileCubit extends HydratedCubit<ProfileState> {
  ProfileCubit(this.profileRepo) : super(ProfileInitial()) {
    checkAuthStatus();
  }

  final ProfileRepo profileRepo;

  Future<void> getProfile({bool navigateOnVipChange = false}) async {
    emit(ProfileLoading());

    try {
      final ApiResponse apiResponse = await profileRepo.getProfile();

      if (apiResponse.response?.statusCode == 200) {
        final UserModel profile = UserModel.fromJson(
          apiResponse.response!.data['body'] as Map<String, dynamic>,
        );

        final bool oldVip = AppStrings.isVip;
        final bool oldVipChat = AppStrings.isVipChat;
        await AppStrings.setVip(
          isVip: profile.isVip,
          isVipChat: profile.isVipChat,
        );

        await profileRepo.saveCurrentUser(profile);
        final String? dbId = profile.id;
        if (dbId != null && dbId.isNotEmpty) {
          await logInToRevenueCat(dbId);
          appData.appUserID = await Purchases.appUserID;
        }

        final String? productId = profile.subscriptions?.isNotEmpty ?? false
            ? profile.subscriptions!.first.productId
            : null;

        try {
          final BuildContext? context = Get.context;
          if (context != null) {
            final NotificationsCubit notificationsCubit = context
                .read<NotificationsCubit>();

            await notificationsCubit.syncTopicsWithBackendProductId(productId);

            await notificationsCubit.initFcmTokenSafelyAndSendToBackend();
          }
        } catch (e) {
          debugPrint('ProfileCubit: failed to sync topics / init token: $e');
        }

        if (navigateOnVipChange && !oldVip && AppStrings.isVip) {
          RouterHelper.getSuccessSubscriptionRoute(
            action: RouteAction.pushReplacement,
          );
        }

        emit(ProfileSuccess(profile));
      } else {
        emit(ProfileError(apiResponse.error.toString()));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final bool isLoggedIn = await profileRepo.isLoggedIn();
      print('Is logged in: $isLoggedIn');

      if (isLoggedIn) {
        await getProfile();
      } else {
        emit(ProfileInitial());
      }
    } catch (e) {
      emit(ProfileInitial());
    }
  }

  Future<bool> isLoggedIn() async {
    return profileRepo.isLoggedIn();
  }

  Future<String> getToken() async {
    return profileRepo.sharedPreferences.getString('token') ?? '';
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(ProfileLoading());
    final ApiResponse apiResponse = await profileRepo.updateProfile(data);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final UserModel profile = UserModel.fromJson(
        apiResponse.response!.data['body'] as Map<String, dynamic>,
      );
      emit(ProfileSuccess(profile));
    } else {
      emit(ProfileError(apiResponse.error.toString()));
    }
  }

  Future<bool> isCurrentUser(String s) async {
    final UserModel? userModel = await profileRepo.currentUser();
    return userModel?.id == s;
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['profile'] != null) {
        final Map<String, dynamic> profileJson =
            json['profile'] as Map<String, dynamic>;
        final UserModel profile = UserModel.fromJson(profileJson);
        return ProfileSuccess(profile);
      }
      return ProfileInitial();
    } catch (e) {
      return ProfileInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    if (state is ProfileSuccess) {
      return <String, dynamic>{'profile': state.profile.toJson()};
    }
    return null;
  }
}
