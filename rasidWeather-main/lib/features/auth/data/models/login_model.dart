import 'dart:io';

import 'package:flutter/src/widgets/icon_data.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import '../../../../data/model/subscription_model.dart';
import '../../../../enums/link_type.dart';

class LoginModel {

  LoginModel(
      {this.id,
      this.name,
      this.avatar,
      this.phone,
      this.bio,
      this.blocked,
      this.email,
      this.isSubscribed,
      this.isVerified,
      this.emailVerifiedAt,
      this.lastActivity,
      this.fcmId,
      this.createdAt,
      this.removeAt,
      this.updatedAt,
      this.expiresIn,
      this.token,
      this.refreshToken,
      required this.isVipChat,
      this.linkedSocialAccount,
      this.subscriptions});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        id: json['id']?.toString(),
        name: json['name']?.toString(),
        avatar: json['avatar'] == null
            ? null
            : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
        phone: json['phone']?.toString(),
        bio: json['bio']?.toString(),
        blocked: json['blocked']?.toString(),
        email: json['email']?.toString(),
        isSubscribed: json['is_subscribed']?.toString(),
        isVerified: json['isVerified']?.toString(),
        emailVerifiedAt: json['email_verified_at'] == null
            ? null
            : DateTime.parse(json['email_verified_at'].toString()),
        lastActivity: json['last_activity'] == null
            ? null
            : DateTime.parse(json['last_activity'].toString()),
        fcmId: json['fcm_id']?.toString(),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'].toString()),
        removeAt: json['remove_at'] == null
            ? null
            : DateTime.parse(json['remove_at'].toString()),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'].toString()),
        expiresIn: json['expires_in'] is int
            ? json['expires_in'] as int
            : int.tryParse(json['expires_in']?.toString() ?? ''),
        token: (json['token'] ?? json['access_token'] ?? json['auth_token'])
            ?.toString(),
        refreshToken: json['refresh_token']?.toString(),
        subscriptions: json['subscriptions'] == null
            ? <SubscriptionModel>[]
            : List<SubscriptionModel>.from(
                (json['subscriptions']! as Iterable).map(
                  (x) => SubscriptionModel.fromJson(
                    x as Map<String, dynamic>,
                  ),
                ),
              ),
        linkedSocialAccount: json['linkedSocialAccount'] == null
            ? <LinkedSocialAccount>[]
            : List<LinkedSocialAccount>.from(
                (json['linkedSocialAccount']! as Iterable).map(
                  (x) => LinkedSocialAccount.fromJson(
                    x as Map<String, dynamic>,
                  ),
                ),
              ),
        isVipChat: (json['isVipChat'] ?? json['is_vip_chat'] ?? false) == true,
      );
  final String? id;
  final String? name;
  final Avatar? avatar;
  final String? phone;
  final String? bio;
  final String? blocked;
  final String? email;
  final String? isSubscribed;
  final String? isVerified;
  final DateTime? emailVerifiedAt;
  final DateTime? lastActivity;
  final String? fcmId;
  final DateTime? createdAt;
  final DateTime? removeAt;
  final DateTime? updatedAt;
  final int? expiresIn;
  final String? token;
  final String? refreshToken;
  List<LinkedSocialAccount>? linkedSocialAccount;
  List<SubscriptionModel>? subscriptions;
  bool isVipChat;

  bool get isVip => subscriptions != null && subscriptions!.isNotEmpty;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'avatar': avatar?.toJson(),
        'phone': phone,
        'bio': bio,
        'blocked': blocked,
        'email': email,
        'is_subscribed': isSubscribed,
        'isVerified': isVerified,
        'email_verified_at': emailVerifiedAt,
        'last_activity': lastActivity?.toIso8601String(),
        'fcm_id': fcmId,
        'created_at': createdAt?.toIso8601String(),
        'remove_at': removeAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'expires_in': expiresIn,
        'token': token,
        'refresh_token': refreshToken,
        'subscriptions': subscriptions == null ? <SubscriptionModel>[] : List<dynamic>.from(subscriptions!.map((SubscriptionModel x) => x)),
        'linkedSocialAccount':
            linkedSocialAccount == null ? <LinkedSocialAccount>[] : List<dynamic>.from(linkedSocialAccount!.map((LinkedSocialAccount x) => x)),
        'isVipChat': isVipChat,
      };
}

class Avatar {

  Avatar({
    this.main,
    this.tiny,
    this.thumb,
    this.original,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        main: json['main'].toString(),
        tiny: json['tiny'].toString(),
        thumb: json['thumb'].toString(),
        original: json['original'].toString(),
      );
  final String? main;
  final String? tiny;
  final String? thumb;
  final String? original;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'main': main,
        'tiny': tiny,
        'thumb': thumb,
        'original': original,
      };
}

class LinkedSocialAccount {
  LinkedSocialAccount({
    this.id,
    this.userId,
    this.providerId,
    this.providerName,
    this.createdAt,
    this.updatedAt,
  });

  factory LinkedSocialAccount.fromJson(Map<String, dynamic> json) => LinkedSocialAccount(
        id: json['id'].toString(),
        userId: json['user_id'].toString(),
        providerId: json['provider_id'].toString(),
        providerName: json['provider_name'].toString(),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'].toString()),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'].toString()),
      );

  String? id;
  String? userId;
  String? providerId;
  String? providerName;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_id': userId,
        'provider_id': providerId,
        'provider_name': providerName,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  bool get isGoogleLinked => providerName == 'google';

  bool get isAppleLinked => providerName == 'apple';

  // get isFacebookLinked => providerName == 'facebook';
  IconData get icon => providerName == 'google'
      ? FontAwesome.google
      : providerName == 'apple'
          ? FontAwesome.apple
          : FontAwesome.facebook;

  LinkType get type => providerName == 'google'
      ? LinkType.google
      : providerName == 'apple'
          ? LinkType.apple
          : LinkType.facebook;

  static List<Map<String, dynamic>> list = <Map<String, dynamic>>[
    if (Platform.isAndroid)
      <String, dynamic>{
        'type': LinkType.google,
        'icon': FontAwesome.google,
        'label': 'Google',
      },
    if (Platform.isIOS)
      <String, dynamic>{
        'type': LinkType.apple,
        'icon': FontAwesome.apple,
        'label': 'Apple',
      },
  ];
}
