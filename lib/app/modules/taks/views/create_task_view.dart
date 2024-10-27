import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../home/views/app_color.dart';
import '../../home/views/widget_background.dart';

class CreateTaskView extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String description;
  final String date;

  CreateTaskView({
    required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
    this.date = '',
  });

  @override
  _CreateTaskviewState createState() => _CreateTaskviewState();
}

class _CreateTaskviewState extends State<CreateTaskView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Ensure Firebase is initialized correctly
  final AppColor appColor = AppColor();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  
  late double widthScreen;
  late double heightScreen;
  DateTime date = DateTime.now().add(Duration(days: 1));
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      date = DateFormat('dd MMMM yyyy').parse(widget.date);
      controllerName.text = widget.name;
      controllerDescription.text = widget.description;
      controllerDate.text = widget.date;
    } else {
      controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    heightScreen = mediaQueryData.size.height;

    return Scaffold(
      backgroundColor: appColor.colorPrimary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildWidgetFormPrimary(),
          SizedBox(height: 16.0),
          _buildWidgetFormSecondary(),
          isLoading
              ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(appColor.colorTertiary)))
              : _buildWidgetButtonCreateTask(),
        ],
      ),
    );
  }

  Widget _buildWidgetFormPrimary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: Colors.grey[800]),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.isEdit ? 'Edit\nTask' : 'Create\nNew Task',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.grey[800]),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controllerName,
            decoration: InputDecoration(labelText: 'Name'),
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controllerDescription,
              decoration: InputDecoration(
                labelText: 'Description',
                suffixIcon: Icon(Icons.description),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllerDate,
              decoration: InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.today),
              ),
              style: TextStyle(fontSize: 18.0),
              readOnly: true,
              onTap: _selectDate,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime today = DateTime.now();
    DateTime? datePicker = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: today,
      lastDate: DateTime(2025),
    );
    if (datePicker != null) {
      date = datePicker;
      controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
    }
  }

  Widget _buildWidgetButtonCreateTask() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColor.colorTertiary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
        child: Text(widget.isEdit ? 'UPDATE TASK' : 'CREATE TASK'),
        onPressed: _handleSubmitTask,
      ),
    );
  }

  Future<void> _handleSubmitTask() async {
    String name = controllerName.text;
    String description = controllerDescription.text;
    String date = controllerDate.text;

    if (name.isEmpty) {
      _showSnackBarMessage('Name is required');
      return;
    } else if (description.isEmpty) {
      _showSnackBarMessage('Description is required');
      return;
    }

    setState(() => isLoading = true);
    if (widget.isEdit) {
      await _updateTask(name, description, date);
    } else {
      await _createTask(name, description, date);
    }
  }

  Future<void> _updateTask(String name, String description, String date) async {
    DocumentReference documentTask = firestore.doc('tasks/${widget.documentId}');
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot task = await transaction.get(documentTask);
      if (task.exists) {
        await transaction.update(documentTask, <String, dynamic>{
          'name': name,
          'description': description,
          'date': date,
        });
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _createTask(String name, String description, String date) async {
    CollectionReference tasks = firestore.collection('tasks');
    DocumentReference result = await tasks.add(<String, dynamic>{
      'name': name,
      'description': description,
      'date': date,
    });
    if (result.id.isNotEmpty) {
      Navigator.pop(context, true);
    }
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
