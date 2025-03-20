import 'package:flutter/material.dart';
import 'package:keralatour/Admin_pages/dash_tabs/SocialMedia/class_social.dart';
import 'package:keralatour/Controller/user_controller.dart';
import 'package:keralatour/Widgets/custon_appbar.dart';
import 'package:provider/provider.dart';

class UserMessagesTable extends StatefulWidget {
  const UserMessagesTable({Key? key}) : super(key: key);

  @override
  State<UserMessagesTable> createState() => _UserMessagesTableState();
}

class _UserMessagesTableState extends State<UserMessagesTable> {
  late Future<List<SocialMedia>> futureMessages;

  @override
  void initState() {
    super.initState();
    futureMessages =
        Provider.of<UserProvider>(context, listen: false).getSocialMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'User Messages',
      ),
      body: FutureBuilder<List<SocialMedia>>(
        future: futureMessages,
        builder: (context, AsyncSnapshot<List<SocialMedia>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No messages available.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4,
                  child: DataTable(
                    columnSpacing: 20.0,
                    headingRowColor: WidgetStateColor.resolveWith(
                        (states) => Colors.blueGrey),
                    dataRowMinHeight: 50,
                    dataRowMaxHeight: 60,
                    columns: _buildColumns(),
                    rows: snapshot.data!.map((socialMedia) {
                      return DataRow(
                        cells: _buildCells(socialMedia),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    const headerStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

    return const [
      DataColumn(label: Text('User', style: headerStyle)),
      DataColumn(label: Text('Time', style: headerStyle)),
      DataColumn(label: Text('Latitude', style: headerStyle)),
      DataColumn(label: Text('Longitude', style: headerStyle)),
      DataColumn(label: Text('Speed', style: headerStyle)),
      DataColumn(label: Text('Message', style: headerStyle)),
    ];
  }

  List<DataCell> _buildCells(SocialMedia socialMedia) {
    return [
      DataCell(_styledText(socialMedia.user)),
      DataCell(_styledText(socialMedia.time)),
      DataCell(_styledText(socialMedia.latitude)),
      DataCell(_styledText(socialMedia.longitude)),
      DataCell(_styledText(socialMedia.speed)),
      DataCell(
        SizedBox(
          width: 200,
          child: Text(
            socialMedia.messages,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ),
    ];
  }

  Widget _styledText(String text) {
    return Text(text, style: const TextStyle(fontSize: 14));
  }
}
