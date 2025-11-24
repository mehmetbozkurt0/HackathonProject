import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/storage_service.dart';
import '../widgets/glass_container.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  List<Map<String, dynamic>> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final savedDevices = await StorageService().loadDevices();
    if (savedDevices.isNotEmpty) {
      setState(() { _devices = savedDevices; _isLoading = false; });
    } else {
      setState(() {
        _devices = [
          {'id': '1', 'name': 'Ana İnverter', 'type': 'Inverter', 'status': 'Online', 'power': '4.2 kW', 'iconCode': 0xf0593},
          {'id': '2', 'name': 'Tesla Powerwall', 'type': 'Batarya', 'status': 'Charging', 'power': '+2.1 kW', 'iconCode': 0xf585},
          {'id': '3', 'name': 'Akıllı Sayaç', 'type': 'Sayaç', 'status': 'Online', 'power': '--', 'iconCode': 0xe5d8},
        ];
        _isLoading = false;
      });
      StorageService().saveDevices(_devices);
    }
  }

  void _addDevice(String name, String type) {
    setState(() {
      _devices.add({
        'id': DateTime.now().toString(),
        'name': name,
        'type': type,
        'status': 'Offline',
        'power': '0 kW',
        'iconCode': _getIconCodeForType(type),
      });
    });
    StorageService().saveDevices(_devices);
  }

  void _removeDevice(int index) {
    final removedDevice = _devices[index];
    setState(() { _devices.removeAt(index); });
    StorageService().saveDevices(_devices);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${removedDevice['name']} silindi."),
        action: SnackBarAction(label: "Geri Al", textColor: AppColors.neonBlue, onPressed: () {
            setState(() { _devices.insert(index, removedDevice); });
            StorageService().saveDevices(_devices);
          }),
      ),
    );
  }

  // YENİ EKLENDİ: Durum Değiştirme (Toggle)
  void _toggleDeviceStatus(int index) {
    setState(() {
      if (_devices[index]['status'] == 'Online') {
        _devices[index]['status'] = 'Offline';
      } else if (_devices[index]['status'] == 'Offline') {
        _devices[index]['status'] = 'Online';
      }
      // Charging gibi özel durumlar varsa onlara dokunmuyoruz
    });
    StorageService().saveDevices(_devices);
  }

  int _getIconCodeForType(String type) {
    switch (type) {
      case 'Inverter': return Icons.solar_power.codePoint;
      case 'Batarya': return Icons.battery_std.codePoint;
      case 'Sayaç': return Icons.speed.codePoint;
      default: return Icons.devices_other.codePoint;
    }
  }

  void _showAddDeviceDialog() {
    final TextEditingController nameController = TextEditingController();
    String selectedType = 'Tüketici';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.cardSurface,
          title: const Text("Yeni Cihaz Ekle", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: "Cihaz Adı", labelStyle: TextStyle(color: Colors.white54), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)))),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: AppColors.cardSurface,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Cihaz Tipi", labelStyle: TextStyle(color: Colors.white54)),
                items: ['Inverter', 'Batarya', 'Sayaç', 'Tüketici'].map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                onChanged: (val) => selectedType = val!,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal", style: TextStyle(color: Colors.white54))),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonBlue), onPressed: () { if (nameController.text.isNotEmpty) { _addDevice(nameController.text, selectedType); Navigator.pop(context); } }, child: const Text("Ekle", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cihaz Yönetimi", style: TextStyle(color: Colors.white)), backgroundColor: AppColors.background, iconTheme: const IconThemeData(color: Colors.white), actions: [IconButton(icon: const Icon(Icons.add), onPressed: _showAddDeviceDialog)]),
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _devices.isEmpty
                  ? const Center(child: Text("Henüz kayıtlı cihaz yok.", style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        final iconData = IconData(device['iconCode'] ?? Icons.devices_other.codePoint, fontFamily: 'MaterialIcons');
                        final bool isOnline = device['status'] == 'Online' || device['status'] == 'Charging';

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GlassContainer(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Cihaz İkonu
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                  child: Icon(iconData, color: AppColors.neonBlue, size: 28),
                                ),
                                const SizedBox(width: 16),
                                // Cihaz Bilgileri (Tıklanabilir Alan - Toggle Status)
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _toggleDeviceStatus(index),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(device['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(width: 8, height: 8, decoration: BoxDecoration(color: isOnline ? AppColors.neonGreen : AppColors.neonRed, shape: BoxShape.circle)),
                                            const SizedBox(width: 6),
                                            Text("${device['type']} • ${device['status']}", style: TextStyle(color: isOnline ? AppColors.neonGreen : Colors.white38, fontSize: 12)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Güç Değeri
                                Text(device['power'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                // Silme Butonu
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.neonRed),
                                  onPressed: () => _removeDevice(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}