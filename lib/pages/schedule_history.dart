import 'package:flutter/material.dart';
import 'package:keralatour/pallete.dart';

class ScheduleHistory extends StatelessWidget {
  const ScheduleHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemBuilder: (ctx, index) {
        return const Card(
          elevation: 2,
          surfaceTintColor: Pallete.green,
          shadowColor: Pallete.backgroundColor,
          child: ListTile(
            leading: Text('Date'),
            title: Text('hfh'),
            subtitle: Text('vvv'),
          ),
        );
      },
      itemCount: 4,
      separatorBuilder: (BuildContext ctx, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    );
  }
}
