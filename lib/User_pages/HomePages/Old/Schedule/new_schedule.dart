// // new_schedule.dart

// import 'package:flutter/material.dart';
// import 'package:keralatour/Controller/user_controller.dart';
// import 'package:keralatour/User_pages/HomePages/Schedule/getdata_schedule.dart';
// import 'package:keralatour/User_pages/HomePages/Schedule/schedule.dart';
// import 'package:keralatour/Widgets/bottom_navigation.dart';
// import 'package:keralatour/Widgets/custon_appbar.dart';
// import 'package:keralatour/Widgets/floating_action.dart';
// import 'package:keralatour/Widgets/side_navigator.dart';
// import 'package:keralatour/Widgets/pallete.dart';
// import 'package:provider/provider.dart';

// class NewSchedulePage extends StatefulWidget {
//   final int userId;

//   const NewSchedulePage({Key? key, required this.userId}) : super(key: key);

//   @override
//   State<NewSchedulePage> createState() => _NewSchedulePageState();
// }

// class _NewSchedulePageState extends State<NewSchedulePage> {
//   late Future<List<TourScheduleList>> futureNewSchedule;

//   @override
//   void initState() {
//     super.initState();
//     futureNewSchedule = Provider.of<UserProvider>(context, listen: false)
//         .getTourSchedulesHistory(widget.userId); // Pass userId to fetch data
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white10,
//       appBar: const CustomAppBar(title: 'Tourism - New Schedule'),
//       drawer: NaviBar(userId: widget.userId),
//       bottomNavigationBar:
//           TourBottomNavigator(currentIndex: 0, onTap: (index) {}),
//       floatingActionButton: CustomFloatingActionButton(
//           userId: widget.userId, onAddSchedule: (userId) {}),
//       body: Container(
//         color: Colors.white10,
//         child: FutureBuilder<List<TourScheduleList>>(
//           future: futureNewSchedule,
//           builder: (context, AsyncSnapshot<List<TourScheduleList>> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//               return const Center(child: Text('No new schedules available.'));
//             } else {
//               return ListView.separated(
//                 padding: const EdgeInsets.all(10),
//                 itemBuilder: (context, index) {
//                   final schedule = snapshot.data![index];
//                   if (index == 0) {
//                     // Highlight the latest schedule
//                     return Card(
//                       elevation: 3,
//                       color: Colors.lightGreen[50],
//                       shadowColor: Pallete.backgroundColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: const BorderSide(
//                           color: Colors.green,
//                           width: 2,
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ListTile(
//                           leading: const Icon(Icons.location_on),
//                           title: Text(
//                             'Tour ID: 0000000${schedule.tourId}',
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'From: ${schedule.location}',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold, fontSize: 15),
//                               ),
//                               Text(
//                                 'Total Days: ${schedule.day}',
//                                 style: const TextStyle(
//                                     fontStyle: FontStyle.italic),
//                               ),
//                             ],
//                           ),
//                           trailing: const Icon(Icons.arrow_forward_ios),
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => TourScheduleScreen(
//                                   tourId: schedule.tourId,
//                                   userId: schedule.userId,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     );
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 },
//                 itemCount: snapshot.data!.length,
//                 separatorBuilder: (context, index) =>
//                     const SizedBox(height: 10),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
