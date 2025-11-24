import 'package:flutter/material.dart';
import 'constants.dart'; // AppColors için

// Bildirim Tipleri
enum NotificationType { critical, warning, info, success }

// Bildirim Modeli
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

// Bildirim Servisi (Singleton)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // CANLI TAKİP İÇİN EKLENDİ: Okunmamış sayısını dinleyen bir yayıncı
  // Başlangıçta 2 okunmamış var kabul ediyoruz (Mock data gereği)
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(2);

  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Kritik İnverter Hatası',
      message: 'Ana inverter bağlantısı koptu. Lütfen cihazı kontrol edin.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      type: NotificationType.critical,
      isRead: false, // Okunmamış
    ),
    AppNotification(
      id: '2',
      title: 'Düşük Batarya Uyarısı',
      message: 'Tesla Powerwall şarjı %18 seviyesine indi.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.warning,
      isRead: false, // Okunmamış
    ),
    AppNotification(
      id: '3',
      title: 'Tam Kapasite Şarj',
      message: 'Bataryalarınız %100 doluluk oranına ulaştı.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.success,
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: 'Hava Durumu Uyarısı',
      message: 'Yarın için yoğun bulut bekleniyor. Tüketimi optimize edin.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.info,
      isRead: true,
    ),
    AppNotification(
      id: '5',
      title: 'Haftalık Rapor Hazır',
      message: 'Geçen haftanın üretim raporu oluşturuldu.',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      type: NotificationType.info,
      isRead: true,
    ),
  ];

  List<AppNotification> getUnreadNotifications() {
    return _notifications.where((n) => !n.isRead).toList();
  }

  List<AppNotification> getPastWeekNotifications() {
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _notifications.where((n) => n.timestamp.isAfter(oneWeekAgo)).toList();
  }

  // GÜNCELLENDİ: Okundu yapınca sayacı sıfırla
  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    unreadCountNotifier.value = 0; // Arayüze haber ver: Sayı 0 oldu!
  }

  // GÜNCELLENDİ: Yeni bildirim gelirse sayacı artır (İleride backend gelirse kullanılır)
  void refreshCount() {
    unreadCountNotifier.value = _notifications.where((n) => !n.isRead).length;
  }

  Color getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.critical: return AppColors.neonRed;
      case NotificationType.warning: return Colors.orange;
      case NotificationType.success: return AppColors.neonGreen;
      case NotificationType.info: return AppColors.neonBlue;
    }
  }

  IconData getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.critical: return Icons.error_outline;
      case NotificationType.warning: return Icons.warning_amber_rounded;
      case NotificationType.success: return Icons.check_circle_outline;
      case NotificationType.info: return Icons.info_outline;
    }
  }
}