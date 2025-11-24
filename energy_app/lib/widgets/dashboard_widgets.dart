import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'glass_container.dart'; // GlassContainer dosyanın widgets klasöründe olduğunu varsayıyorum

// 1. ÖZET KARTLARI (EnergyStatusCard)
class EnergyStatusCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const EnergyStatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Icon(Icons.more_horiz, color: Colors.white38),
            ],
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Colors.white60, fontSize: 14)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.trending_up, color: color, size: 16),
              const SizedBox(width: 5),
              Text(subtitle, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}

// 2. AI ÖNERİ KARTI
class AIRecommendationCard extends StatelessWidget {
  const AIRecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24.0),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.neonBlue.withOpacity(0.15),
          AppColors.cardGradientEnd,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.neonBlue),
              SizedBox(width: 10),
              Text("AI Optimizasyon", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Yarın hava bulutlu olacak. Bataryayı gece tarifesinde (02:00 - 05:00) tam kapasite şarj etmeniz önerilir.",
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonBlue,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Öneriyi Uygula", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

// 3. GRAFİK BÖLÜMÜ
class ProductionChartSection extends StatelessWidget {
  const ProductionChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Enerji Akışı (Son 24s)", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Text("Günlük", style: TextStyle(color: Colors.white, fontSize: 12)),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(height: 0.4, label: "00:00"),
                _buildBar(height: 0.3, label: "04:00"),
                _buildBar(height: 0.6, label: "08:00", isHigh: true),
                _buildBar(height: 0.9, label: "12:00", isHigh: true),
                _buildBar(height: 0.7, label: "16:00", isHigh: true),
                _buildBar(height: 0.5, label: "20:00"),
                _buildBar(height: 0.4, label: "23:59"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar({required double height, required String label, bool isHigh = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 150 * height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isHigh 
                ? [AppColors.neonGreen.withOpacity(0.3), AppColors.neonGreen]
                : [Colors.white10, Colors.white24],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}

// 4. LOG LİSTE ELEMANI
class LogListItem extends StatelessWidget {
  final String time;
  final String message;
  final String type;
  final String amount;

  const LogListItem({super.key, required this.time, required this.message, required this.type, required this.amount});

  @override
  Widget build(BuildContext context) {
    Color typeColor = Colors.white;
    IconData typeIcon = Icons.info;

    switch (type) {
      case 'AI': typeColor = AppColors.neonBlue; typeIcon = Icons.auto_awesome; break;
      case 'WARN': typeColor = AppColors.neonRed; typeIcon = Icons.warning_amber_rounded; break;
      case 'SELL': typeColor = AppColors.neonGreen; typeIcon = Icons.attach_money; break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardGradientStart,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(typeIcon, color: typeColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: typeColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 5. HEADER (Merhaba Ahmet Bey kısmı)
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Merhaba, Ahmet Bey", style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text("Ev Enerji Durumu", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.neonGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: const Text("AKTİF", style: TextStyle(color: AppColors.neonGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ],
        ),
        const CircleAvatar(
          backgroundColor: Colors.white10,
          radius: 24,
          child: Icon(Icons.notifications_outlined, color: Colors.white),
        )
      ],
    );
  }
}