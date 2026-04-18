// import 'dart:io';
//
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../data/model/base/payload_model.dart';
// import '../features/notifications/data/models/notification_model.dart';
// import '../utils/ui_utils.dart';
//
//
// class DatabaseHelper {
//   DatabaseHelper._privateConstructor();
//   static const String _databaseName = 'NotificationDB1.db';
//   static const int _databaseVersion = 1;
//
//   // Keep notifications for 30 days
//   static const int _maxNotificationAgeDays = 30;
//
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//   static Database? _database;
//
//   Future<Database?> get database async {
//     if (_database != null) {
//       return _database;
//     }
//     _database = await _initDatabase();
//     return _database;
//   }
//
//   Future<Database> _initDatabase() async {
//     final Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     final String path = join(documentsDirectory.path, _databaseName);
//     return openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
//   }
//
//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//     // في الإصدار الأول، لا نحتاج لأي ترقية
//   }
//
//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE ${NotificationType.weather.name} (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         image TEXT,
//         content_available BOOLEAN,
//         reviewable_id TEXT,
//         reviewable_type TEXT,
//         isVideo BOOLEAN,
//         priority TEXT,
//         type TEXT,
//         title TEXT,
//         click_action TEXT,
//         content TEXT,
//         created_at TEXT,
//         actionUrl TEXT,
//         seen INTEGER
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE ${NotificationType.custom.name} (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title TEXT NOT NULL,
//         content TEXT NOT NULL,
//         actionUrl TEXT NOT NULL,
//         reviewable_type TEXT NOT NULL,
//         reviewable_id TEXT NOT NULL,
//         type TEXT NOT NULL,
//         isVideo TEXT NOT NULL,
//         image TEXT NOT NULL,
//         created_at TEXT NOT NULL,
//         content_available TEXT NOT NULL,
//         seen TEXT NOT NULL
//       )
//     ''');
//   }
//
//   Future<void> insert(Map<String, dynamic> payload, {NotificationType type = NotificationType.weather}) async {
//     try {
//       // تنظيف وتحضير البيانات
//       final Map<String, dynamic> sanitizedPayload = <String, dynamic>{
//         'title': payload['title']?.toString() ?? '',
//         'content': payload['content']?.toString() ?? '',
//         'actionUrl': payload['actionUrl']?.toString() ?? '',
//         'reviewable_type': payload['reviewable_type']?.toString() ?? '',
//         'reviewable_id': payload['reviewable_id']?.toString() ?? '',
//         'type': type.name,
//         'isVideo': payload['isVideo']?.toString() ?? 'false',
//         'image': payload['image']?.toString() ?? '',
//         'content_available': payload['content_available']?.toString() ?? 'true',
//         'created_at': DateTime.now().toIso8601String(),
//         'seen': '0',
//       };
//
//       final Database? db = await database;
//       await db!.insert(
//         type.name,
//         sanitizedPayload,
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//
//       printLog('تم حفظ الإشعار بنجاح');
//     } catch (error) {
//       printLog('خطأ في حفظ الإشعار: $error');
//       rethrow;
//     }
//   }
//
//   Future<void> deleteOldNotifications() async {
//     try {
//       final Database? db = await database;
//       final DateTime threshold = DateTime.now().subtract(const Duration(days: _maxNotificationAgeDays));
//
//       // Delete old notifications from both tables
//       for (final NotificationType type in NotificationType.values) {
//         await db?.delete(
//           type.name,
//           where: 'created_at < ?',
//           whereArgs: <Object?>[threshold.toIso8601String()],
//         );
//       }
//     } catch (e) {
//       printLog('Error deleting old notifications: $e');
//     }
//   }
//
//   Future<List<PayloadModel>> getNotifications({
//     NotificationType type = NotificationType.weather,
//     int offset = 0,
//     int limit = 20,
//   }) async {
//     final Database? db = await database;
//     final List<Map<String, Object?>>? maps = await db?.query(
//       type.name,
//       columns: PayloadModel.columnNames,
//       orderBy: 'created_at DESC',
//       limit: limit,
//       offset: offset,
//     );
//
//     return List.generate(maps!.length, (int i) {
//       return PayloadModel.fromJson(maps[i]);
//     });
//   }
//
//   Future<int> getUnreadCount({NotificationType type = NotificationType.weather}) async {
//     try {
//       final Database? db = await database;
//       final List<Map<String, dynamic>> result = await db!.rawQuery('''
//         SELECT COUNT(*) as count
//         FROM ${type.name}
//         WHERE seen IS NULL OR seen = 0 OR seen = '0'
//       ''');
//
//       final int count = result.first['count'] as int? ?? 0;
//       printLog('عدد الإشعارات غير المقروءة في ${type.name}: $count');
//       return count;
//     } catch (e) {
//       printLog('خطأ في حساب الإشعارات غير المقروءة: $e');
//       return 0;
//     }
//   }
//
//   Future<void> markAsRead(int id, {NotificationType? type}) async {
//     try {
//       final Database? db = await database;
//
//       if (type != null) {
//         // تحديث في جدول محدد فقط
//         await db!.update(
//           type.name,
//           <String, Object?>{'seen': 1},
//           where: 'id = ?',
//           whereArgs: <Object?>[id],
//         );
//       } else {
//         // تحديث في كلا الجدولين
//         await db!.update(
//           NotificationType.weather.name,
//           <String, Object?>{'seen': 1},
//           where: 'id = ?',
//           whereArgs: <Object?>[id],
//         );
//
//         await db.update(
//           NotificationType.custom.name,
//           <String, Object?>{'seen': 1},
//           where: 'id = ?',
//           whereArgs: <Object?>[id],
//         );
//       }
//
//       printLog('تم تحديث حالة الإشعار رقم $id إلى مقروء');
//     } catch (e) {
//       printLog('خطأ في تحديث حالة الإشعار: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> markAllAsRead({NotificationType? type}) async {
//     try {
//       final Database? db = await database;
//
//       if (type != null) {
//         // تحديث كل الإشعارات في جدول محدد
//         await db!.update(
//           type.name,
//           <String, Object?>{'seen': 1},
//           where: 'seen = 0 OR seen = "0" OR seen IS NULL',
//         );
//       } else {
//         // تحديث كل الإشعارات في كلا الجدولين
//         await db!.update(
//           NotificationType.weather.name,
//           <String, Object?>{'seen': 1},
//           where: 'seen = 0 OR seen = "0" OR seen IS NULL',
//         );
//
//         await db.update(
//           NotificationType.custom.name,
//           <String, Object?>{'seen': 1},
//           where: 'seen = 0 OR seen = "0" OR seen IS NULL',
//         );
//       }
//
//       printLog('تم تحديث جميع الإشعارات إلى مقروءة');
//     } catch (e) {
//       printLog('خطأ في تحديث حالة الإشعارات: $e');
//       rethrow;
//     }
//   }
//
//   Future<PayloadModel?> queryNotification(int id, {NotificationType type = NotificationType.weather}) async {
//     final Database? db = await database;
//     final List<Map<String, dynamic>> maps = await db!.query(
//       type.name,
//       columns: PayloadModel.columnNames,
//       where: 'id = ?',
//       whereArgs: <Object?>[id],
//     );
//     if (maps.isEmpty) {
//       return null;
//     }
//     return PayloadModel.fromJson(maps.first);
//   }
//
//   Future<void> updateNotification(PayloadModel notification) async {
//     if (notification.id == null) {
//       // If no ID, treat it as an insert
//       await insert(PayloadModel.toJson(notification), type: notification.type == 'weather' ? NotificationType.weather : NotificationType.custom);
//       return;
//     }
//
//     final Database? db = await database;
//     await db!.update(
//       notification.type == 'weather' ? NotificationType.weather.name : NotificationType.custom.name,
//       PayloadModel.toJson(notification),
//       where: 'id = ?',
//       whereArgs: <Object?>[notification.id],
//     );
//   }
//
//   Future<void> deleteNotification(int id) async {
//     final Database? db = await database;
//     await db!.delete(
//       NotificationType.weather.name,
//       where: 'id = ?',
//       whereArgs: <Object?>[id],
//     );
//     await db.delete(
//       NotificationType.custom.name,
//       where: 'id = ?',
//       whereArgs: <Object?>[id],
//     );
//   }
//
//   Future<bool> hasUnreadNotifications() async {
//     try {
//       final Database? db = await database;
//
//       // التحقق من وجود إشعارات غير مقروءة في جدول الطقس
//       final List<Map<String, dynamic>> weatherResult = await db!.rawQuery('''
//         SELECT COUNT(*) as count
//         FROM ${NotificationType.weather.name}
//         WHERE seen IS NULL OR seen = 0 OR seen = '0'
//         LIMIT 1
//       ''');
//
//       final int weatherCount = (weatherResult.first['count'] as int?) ?? 0;
//       if (weatherCount > 0) {
//         return true;
//       }
//
//       // التحقق من وجود إشعارات غير مقروءة في جدول المحتوى
//       final List<Map<String, dynamic>> contentResult = await db.rawQuery('''
//         SELECT COUNT(*) as count
//         FROM ${NotificationType.custom.name}
//         WHERE seen IS NULL OR seen = 0 OR seen = '0'
//         LIMIT 1
//       ''');
//
//       final int contentCount = (contentResult.first['count'] as int?) ?? 0;
//       return contentCount > 0;
//     } catch (e) {
//       printLog('خطأ في التحقق من الإشعارات غير المقروءة: $e');
//       return false;
//     }
//   }
//
//   Future<bool> hasUnreadNotificationsForType(NotificationType type) async {
//     try {
//       final Database? db = await database;
//       final List<Map<String, dynamic>> result = await db!.rawQuery('''
//         SELECT COUNT(*) as count
//         FROM ${type.name}
//         WHERE seen IS NULL OR seen = 0 OR seen = '0'
//         LIMIT 1
//       ''');
//
//       final int count = (result.first['count'] as int?) ?? 0;
//       return count > 0;
//     } catch (e) {
//       printLog('خطأ في التحقق من الإشعارات غير المقروءة لنوع ${type.name}: $e');
//       return false;
//     }
//   }
// }
