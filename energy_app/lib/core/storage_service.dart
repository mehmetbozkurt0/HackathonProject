import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Cihazları Kaydet
  Future<void> saveDevices(List<Map<String, dynamic>> devices) async {
    final prefs = await SharedPreferences.getInstance();
    // Listeyi JSON String'e çevirip saklıyoruz
    String encodedData = json.encode(devices);
    await prefs.setString('user_devices', encodedData);
  }

  // Cihazları Yükle
  Future<List<Map<String, dynamic>>> loadDevices() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString('user_devices');
    
    if (encodedData != null) {
      List<dynamic> decoded = json.decode(encodedData);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return []; // Eğer kayıt yoksa boş liste dön
  }

  // (Opsiyonel) Raporları Kaydetmek istersen buraya benzer fonksiyonlar ekleyebilirsin
}