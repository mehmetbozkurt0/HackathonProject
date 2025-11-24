import 'package:flutter/material.dart';
import '../core/constants.dart';

class RegionalComparisonScreen extends StatelessWidget {
  const RegionalComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bölgesel Kıyaslama"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Bu ayki enerji tüketiminiz bölge ortalamasından %15 daha verimli.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 30),
            
            // Kıyaslama Çubukları
            _buildComparisonBar("Sizin Eviniz", 0.6, AppColors.neonGreen, "240 kWh"),
            const SizedBox(height: 20),
            _buildComparisonBar("Mahalle Ortalaması", 0.8, AppColors.neonBlue, "310 kWh"),
            const SizedBox(height: 20),
            _buildComparisonBar("En Verimli Ev", 0.4, Colors.amber, "180 kWh"),
            
            const Spacer(),
            // Alt Bilgi Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.neonBlue.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber, size: 40),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Tebrikler! Bölgenizdeki en verimli %20'lik dilimdesiniz.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonBar(String label, double percent, Color color, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 12,
            backgroundColor: Colors.grey[800],
            color: color,
          ),
        ),
      ],
    );
  }
}