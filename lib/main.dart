import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
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
  DateTime currentDate = DateTime.now();

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
          _dateOfBirthPicker('Date of Birth', _mainBloc.dateOfBirth,
              _mainBloc.sinkDateOfBirth, Icons.date_range),
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
              inputFormatterLength: 150),
          SizedBox(
              height: 20.0
          ),
          _saveButton('Save', _mainBloc.mandatoryFieldsChecked),
          SizedBox(
            height: 40.0,
          )
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

  Widget _dateOfBirthPicker(String labelText, Stream stream,
      Function sinkDateOfBirth, IconData iconData) {
    return StreamBuilder(
      stream: stream,
      initialData: '',
      builder: (context, snapshot) {
        return DateTimeField(
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
          format: DateFormat("yyyy-MM-dd"),
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                initialDate: currentValue ?? currentDate,
                lastDate: currentDate);
          },
          onChanged: (value) {
            sinkDateOfBirth(value);
          },
        );
      },
    );
  }

  Widget _saveButton(String title, Stream stream) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 45,
          child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                return RaisedButton(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  color: Colors.green,
                  splashColor: Colors.white30,
                  onPressed: snapshot.hasData ? () {} : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                );
              }),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mainBloc = BlocProvider.of(context);
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
