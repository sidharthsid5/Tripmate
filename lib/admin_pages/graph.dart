// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:keralatour/controller/user_controller.dart';
// import 'package:provider/provider.dart';

// class BarChartWidget extends StatefulWidget {
//   const BarChartWidget({Key? key}) : super(key: key);

//   @override
//   State<BarChartWidget> createState() => _BarChartWidgetState();
// }

// class _BarChartWidgetState extends State<BarChartWidget> {
//   late Future<List<TouristDetail>> futureTouristDetails;

//   @override
//   void initState() {
//     super.initState();
//     futureTouristDetails =
//         Provider.of<UserProvider>(context, listen: false).fetchTouristDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<TouristDetail>>(
//       future: futureTouristDetails,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No data available'));
//         } else {
//           return MaterialApp(
//             home: Scaffold(
//               appBar: AppBar(
//                 title: const Text('Professional Chart Example'),
//               ),
//               body: ListView(
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Text(
//                       'Male to Female Ratio',
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   Container(
//                     height: 300,
//                     padding: const EdgeInsets.all(8.0),
//                     child: MaleFemaleRatioChart(data: snapshot.data!),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// class MaleFemaleRatioChart extends StatelessWidget {
//   final List<TouristDetail> data;

//   const MaleFemaleRatioChart({Key? key, required this.data}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var maleCount = data.where((detail) => detail.sex == 'M').length.toDouble();
//     var femaleCount =
//         data.where((detail) => detail.sex == 'F').length.toDouble();

//     // Assuming you want to display ratios based on total counts
//     var total = maleCount + femaleCount;
//     var maleRatio = maleCount / total;
//     var femaleRatio = femaleCount / total;

//     var chartData = [
//       TouristDetail('M', maleRatio as int),
//       TouristDetail('F', femaleRatio as int),
//     ];

//     var series = [
//       charts.Series(
//         id: 'Ratio',
//         data: chartData,
//         domainFn: (TouristDetail ratio, _) => ratio.sex,
//         measureFn: (TouristDetail ratio, _) => ratio.userid,
//         // colorFn: (TouristDetail ratio, _) =>
//         //     charts.ColorUtil.fromDartColor(ratio.color),
//       )
//     ];

//     return charts.BarChart(
//       series.cast<charts.Series<dynamic, String>>(),
//       animate: true,
//       barGroupingType: charts.BarGroupingType.grouped,
//       primaryMeasureAxis: charts.NumericAxisSpec(
//         renderSpec: charts.GridlineRendererSpec(
//           labelStyle: const charts.TextStyleSpec(
//               fontSize: 12, color: charts.MaterialPalette.black),
//           lineStyle: charts.LineStyleSpec(
//               color: charts.MaterialPalette.gray.shadeDefault),
//         ),
//       ),
//       domainAxis: charts.OrdinalAxisSpec(
//         renderSpec: charts.SmallTickRendererSpec(
//           labelStyle: const charts.TextStyleSpec(
//               fontSize: 12, color: charts.MaterialPalette.black),
//           lineStyle: charts.LineStyleSpec(
//               color: charts.MaterialPalette.gray.shadeDefault),
//         ),
//       ),
//     );
//   }
// }

// class TouristDetail {
//   final String? sex;
//   final int userid;

//   TouristDetail(this.sex, this.userid);

//   factory TouristDetail.fromJson(Map<String, dynamic> json) {
//     return TouristDetail(
//       json['Sex'],
//       json['age'],
//     );
//   }
// }
