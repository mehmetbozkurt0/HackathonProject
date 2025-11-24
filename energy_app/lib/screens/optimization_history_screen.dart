import 'package:flutter/material.dart';
import '../widgets/dashboard_widgets.dart'; // LogListItem'ı buradan çekeceğiz

class OptimizationHistoryScreen extends StatelessWidget {
  const OptimizationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Optimizasyon Geçmişi"),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          LogListItem(time: "14:30", message: "Batarya şarjı başlatıldı (Güneş Fazlası)", type: "AI", amount: "+2.0 kW"),
          LogListItem(time: "12:00", message: "Şebeke satışı (Puant Saat)", type: "SELL", amount: "+4.1 kW"),
          LogListItem(time: "10:15", message: "Klima eco moda alındı", type: "AI", amount: "-1.2 kW"),
          LogListItem(time: "09:30", message: "Çamaşır makinesi beklemeye alındı", type: "WARN", amount: "0 kW"),
          LogListItem(time: "Dün", message: "Günlük özet: %28 Tasarruf", type: "INFO", amount: "₺45.2"),
          LogListItem(time: "Dün", message: "Araç şarjı tamamlandı", type: "EV", amount: "-15 kW"),
        ],
      ),
    );
  }
}