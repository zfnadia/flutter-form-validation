import 'package:flutter/material.dart';
import 'package:flutter_form_validation/src/bloc/blocProvider.dart';
import 'package:flutter_form_validation/src/bloc/mainBloc.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: MainBloc(),
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MainBloc _mainBloc;
  TextEditingController _controller;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Validation Example'),
      ),
      body: ListView(
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('Username', _mainBloc.username,
              _mainBloc.sinkUsername, Icons.person,
              inputFormatterLength: 60),
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('Email', _mainBloc.emailAddress,
              _mainBloc.sinkEmailAddress, Icons.email),
          SizedBox(
            height: 15.0,
          ),
          _dateOfBirthPicker('Date of Birth', _mainBloc.dateOfBirth, Icons.date_range),
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('Phone Number', _mainBloc.phoneNumber,
              _mainBloc.sinkPhoneNumber, Icons.phone),
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('Address', _mainBloc.address,
              _mainBloc.sinkAddress, Icons.location_city,
              inputFormatterLength: 100),
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('About Me', _mainBloc.aboutMe,
              _mainBloc.sinkAboutMe, Icons.assignment_ind,
              inputFormatterLength: 150)
        ],
      ),
    );
  }

  Widget _reusableTextField(String labelText, Stream stream,
      Function changeFunction, IconData iconData,
      {int inputFormatterLength}) {
    return StreamBuilder(
      stream: stream,
      initialData: '',
      builder: (context, snapshot) {
        return TextField(
          onChanged: (value) {
            changeFunction(value);
          },
          decoration: InputDecoration(
            labelStyle: Decorations.textFieldFocusLabelTextStyle(),
            focusedBorder: Decorations.textFieldFocusOutlineInputBorder(),
            border: Decorations.textFieldFocusOutlineInputBorder(),
            labelText: labelText,
            errorText: snapshot.hasError && snapshot.error is String
                ? snapshot.error
                : null,
            prefixIcon: Icon(
              iconData,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2019, 12));
    if (picked != null && picked != selectedDate) {
      _mainBloc.sinkDateOfBirth(picked);
    } else {
      _mainBloc.sinkDateOfBirth(selectedDate);
    }
  }

  Widget _dateOfBirthPicker(String labelText, Stream stream, IconData iconData) {
    return StreamBuilder(
      stream: stream,
      initialData: '',
      builder: (context, snapshot) {
        _controller.text = snapshot.data.toString();
        return TextField(
          controller: _controller,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            labelStyle: Decorations.textFieldFocusLabelTextStyle(),
            focusedBorder: Decorations.textFieldFocusOutlineInputBorder(),
            border: Decorations.textFieldFocusOutlineInputBorder(),
            labelText: labelText,
            errorText: snapshot.hasError && snapshot.error is String
                ? snapshot.error
                : null,
            prefixIcon: Icon(
              iconData,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainBloc = BlocProvider.of(context);
    _controller = TextEditingController(text: "${DateFormat('yyyy-MM-dd').format(selectedDate)}");
  }

  @override
  void dispose() {
    super.dispose();
    _mainBloc.clearAllData();
  }
}

class Decorations {
  static TextStyle textFieldFocusLabelTextStyle() {
    return TextStyle(fontSize: 16.0, color: Colors.grey);
  }

  static OutlineInputBorder textFieldFocusOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
      borderRadius: BorderRadius.circular(4.0),
    );
  }

  static OutlineInputBorder textFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0),
      borderRadius: BorderRadius.circular(4.0),
    );
  }
}
