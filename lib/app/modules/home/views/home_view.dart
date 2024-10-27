import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../taks/views/create_task_view.dart';
import 'app_color.dart';
import 'widget_background.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Ensure Firebase is initialized correctly
  final AppColor appColor = AppColor();

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: appColor.colorPrimary,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildTodoList(widthScreen, heightScreen, context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskView(isEdit: false),
            ),
          );
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task has been created')),
            );
            setState(() {});
          }
        },
        backgroundColor: appColor.colorTertiary,
      ),
    );
  }

  Container _buildTodoList(double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'Todo List',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('tasks').orderBy('date').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final documents = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final document = documents[index];
                    final Map<String, dynamic> task = document.data() as Map<String, dynamic>;
                    final String strDate = task['date'] ?? '';
                    final List<String> dateParts = strDate.split(' ');
                    final String day = dateParts.isNotEmpty ? dateParts[0] : '';
                    final String month = dateParts.length > 1 ? dateParts[1] : '';

                    return Card(
                      child: ListTile(
                        title: Text(task['name'] ?? 'Untitled Task'),
                        subtitle: Text(
                          task['description'] ?? 'No description',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: _buildDateIndicator(day, month),
                        trailing: _buildPopupMenu(document),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Column _buildDateIndicator(String day, String month) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            color: appColor.colorSecondary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Text(month, style: TextStyle(fontSize: 12.0)),
      ],
    );
  }

  PopupMenuButton<String> _buildPopupMenu(DocumentSnapshot document) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ];
      },
      onSelected: (value) async {
        if (value == 'edit') {
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskView(
                isEdit: true,
                documentId: document.id,
                name: document['name'],
                description: document['description'],
                date: document['date'],
              ),
            ),
          );
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task has been updated')),
            );
            setState(() {});
          }
        } else if (value == 'delete') {
          await firestore.collection('tasks').doc(document.id).delete();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Task has been deleted')),
          );
          setState(() {});
        }
      },
      child: Icon(Icons.more_vert),
    );
  }
}
