import 'package:flutter/material.dart';

class SalesDashboardScreen extends StatelessWidget {
  const SalesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Hey James! 👋', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SaleSummarySection(),
              SizedBox(height: 20),
              // InventoryOverviewSection(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.blue),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment, color: Colors.blue),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add, color: Colors.blue),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.blue),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blueAccent,
        onTap: (index) {},
      ),
    );
  }
}

class SaleSummarySection extends StatelessWidget {
  const SaleSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Active Users',
                amount: '47',
                increase: true,
                cardColor: Colors.blue[100]!,
                textColor: Colors.blue[900]!,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                title: 'Downloads',
                amount: '620',
                increase: true,
                cardColor: Colors.green[100]!,
                textColor: Colors.green[900]!,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Android',
                amount: '500',
                increase: true,
                cardColor: Colors.orange[100]!,
                textColor: Colors.orange[900]!,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SummaryCard(
                title: 'iOS',
                amount: '120',
                increase: true,
                cardColor: Colors.purple[100]!,
                textColor: Colors.purple[900]!,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool increase;
  final Color cardColor;
  final Color textColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.increase,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  increase ? Icons.arrow_upward : Icons.arrow_downward,
                  color: increase ? Colors.green : Colors.red,
                ),
                Text(
                  increase ? 'Increase' : 'Decrease',
                  style: TextStyle(
                    color: increase ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
