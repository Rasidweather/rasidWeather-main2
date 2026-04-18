import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart'; // بدل flutter/src/...
import 'package:fluttericon/font_awesome_icons.dart';

import '../../enums/link_type.dart';
import '../../features/auth/data/models/login_model.dart';
import 'subscription_model.dart';

class UserModel {
  UserModel({
    this.id,
    this.avatar,
    this.name,
    this.email,
    this.phone,
    this.bio,
    this.isOnline,
    this.lastActivity,
    this.isVerified,
    this.emailVerifiedAt,
    this.blocked,
    this.isSubscribed,
    this.fcmId,
    required this.isVipChat,
    this.linkedSocialAccount,
    this.subscriptions,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonMap) {
    final List<SubscriptionModel> subs =
        (jsonMap['subscriptions'] as List<dynamic>?)
            ?.map(
              (x) => SubscriptionModel.fromJson(x as Map<String, dynamic>),
        )
            .toList() ??
            <SubscriptionModel>[];

    final bool vipFlagFromBackend = jsonMap['isVipChat'] == true;

    final bool isActive = _isSubscriptionActive(subs);
    final bool vipChat = isActive && vipFlagFromBackend;

    return UserModel(
      id: jsonMap['id']?.toString(),
      avatar: jsonMap['avatar'] == null
          ? null
          : Avatar.fromJson(jsonMap['avatar'] as Map<String, dynamic>),
      name: jsonMap['name']?.toString() ?? '',
      email: jsonMap['email']?.toString() ?? '',
      phone: jsonMap['phone']?.toString() ?? '',
      bio: jsonMap['bio']?.toString(),
      isOnline: jsonMap['isOnline'] as int?,
      lastActivity: jsonMap['last_activity'] == null
          ? null
          : DateTime.tryParse(jsonMap['last_activity'].toString()),
      isVerified: jsonMap['isVerified']?.toString(),
      emailVerifiedAt: jsonMap['email_verified_at'] == null
          ? null
          : DateTime.tryParse(jsonMap['email_verified_at'].toString()),
      blocked: jsonMap['blocked']?.toString(),
      fcmId: jsonMap['fcm_id']?.toString(),
      isSubscribed: (jsonMap['is_subscribed'] as bool?) ?? false,
      subscriptions: subs,
      linkedSocialAccount: jsonMap['linkedSocialAccount'] == null
          ? <LinkedSocialAccount>[]
          : List<LinkedSocialAccount>.from(
        (jsonMap['linkedSocialAccount'] as Iterable).map(
              (x) => LinkedSocialAccount.fromJson(
            x as Map<String, dynamic>,
          ),
        ),
      ),
      isVipChat: vipChat,
    );
  }

  String? id;
  Avatar? avatar;
  String? name;
  String? email;
  String? phone;
  String? bio;
  int? isOnline;
  DateTime? lastActivity;
  String? isVerified;
  DateTime? emailVerifiedAt;
  String? blocked;
  String? fcmId;
  bool isVipChat;
  bool? isSubscribed;
  List<LinkedSocialAccount>? linkedSocialAccount;
  List<SubscriptionModel>? subscriptions;

  /// VIP (اشتراك فعال)
  bool get isVip => _isSubscriptionActive(subscriptions ?? <SubscriptionModel>[]);

  static bool _isSubscriptionActive(List<SubscriptionModel> subs) {
    if (subs.isEmpty) return false;

    // لو عندك أكثر من اشتراك: أي واحد فعال يعتبر Active
    for (final SubscriptionModel s in subs) {
      if (s.expiredAt == null) return true; // lifetime / unknown => active
      if (s.expiredAt!.isAfter(DateTime.now())) return true;
    }
    return false;
  }

  bool get isGoogleLinked =>
      (linkedSocialAccount ?? <LinkedSocialAccount>[]).any((LinkedSocialAccount e) => e.providerName == 'google');
  bool get isAppleLinked =>
      (linkedSocialAccount ?? <LinkedSocialAccount>[]).any((LinkedSocialAccount e) => e.providerName == 'apple');
  bool get isFacebookLinked =>
      (linkedSocialAccount ?? <LinkedSocialAccount>[]).any((LinkedSocialAccount e) => e.providerName == 'facebook');

  String get userEmail => email ?? '';
  String get userName => name ?? '';
  String? get userPhone => (phone ?? '').isEmpty ? '201026094252' : phone;
  String get userBio => bio ?? '';
  List<LinkedSocialAccount> get accounts => linkedSocialAccount ?? <LinkedSocialAccount>[];

  bool get verified => isVerified == '1';
  bool get online => isOnline == 1;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'avatar': avatar?.toJson(),
    'name': name,
    'email': email,
    'phone': phone,
    'bio': bio,
    'isOnline': isOnline,
    'last_activity': lastActivity?.toIso8601String(),
    'isVerified': isVerified,
    'email_verified_at': emailVerifiedAt?.toIso8601String(),
    'blocked': blocked,
    'is_subscribed': isSubscribed,
    'fcm_id': fcmId,
    'subscriptions': (subscriptions ?? <SubscriptionModel>[]).map((SubscriptionModel x) => x.toJson()).toList(),
    'linkedSocialAccount':
    (linkedSocialAccount ?? <LinkedSocialAccount>[]).map((LinkedSocialAccount x) => x.toJson()).toList(),
    'isVipChat': isVipChat,
  };

  static Future<UserModel> decode(String s) async =>
      UserModel.fromJson(jsonDecode(s) as Map<String, dynamic>);

  String encode() => jsonEncode(toJson());
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

  factory LinkedSocialAccount.fromJson(Map<String, dynamic> json) =>
      LinkedSocialAccount(
        id: json['id']?.toString(),
        userId: json['user_id']?.toString(),
        providerId: json['provider_id']?.toString(),
        providerName: json['provider_name']?.toString(),
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'].toString()),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.tryParse(json['updated_at'].toString()),
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
