import 'package:flutter/material.dart';

import 'stat_card.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'لوحة التحكم',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'نظرة عامة على المنصة',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.8,
              children: const [
                StatCard(
                  title: 'المستخدمون',
                  value: '0',
                  icon: Icons.people,
                ),
                StatCard(
                  title: 'المباريات',
                  value: '0',
                  icon: Icons.sports_soccer,
                ),
                StatCard(
                  title: 'المنشورات',
                  value: '0',
                  icon: Icons.article,
                ),
                StatCard(
                  title: 'البلاغات',
                  value: '0',
                  icon: Icons.report,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}