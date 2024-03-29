import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_form_validation/src/bloc/blocProvider.dart';
import 'package:flutter_form_validation/src/bloc/mainBloc.dart';
import 'package:intl/intl.dart';

/*const String MIN_DATETIME = '1990-05-12';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';*/

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
          _reusableTextField('Username*', _mainBloc.username,
              _mainBloc.sinkUsername, Icons.person,
              textInputType: TextInputType.text, inputFormatterLength: 60),
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('Email*', _mainBloc.emailAddress,
              _mainBloc.sinkEmailAddress, Icons.email,
              textInputType: TextInputType.emailAddress),
          SizedBox(
            height: 15.0,
          ),
          _dateOfBirthPicker('Date of Birth*', _mainBloc.dateOfBirth,
              _mainBloc.sinkDateOfBirth, Icons.date_range),
/*          SizedBox(
            height: 15.0,
          ),
          _cupertinoDateOfBirthPicker('Date of Birth*', _mainBloc.dateOfBirth,
              _mainBloc.sinkDateOfBirth, Icons.date_range),*/
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('Phone Number*', _mainBloc.phoneNumber,
              _mainBloc.sinkPhoneNumber, Icons.phone,
              textInputType: TextInputType.phone, whitelistingTextInputFormatter: WhitelistingTextInputFormatter.digitsOnly),
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('Address', _mainBloc.address,
              _mainBloc.sinkAddress, Icons.location_city,
              textInputType: TextInputType.text, inputFormatterLength: 100),
          SizedBox(
            height: 15.0,
          ),
          _reusableTextField('About Me', _mainBloc.aboutMe,
              _mainBloc.sinkAboutMe, Icons.assignment_ind,
              textInputType: TextInputType.text, inputFormatterLength: 150),
          SizedBox(height: 20.0),
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
      {TextInputType textInputType, int inputFormatterLength, WhitelistingTextInputFormatter whitelistingTextInputFormatter}) {
    return StreamBuilder(
      stream: stream,
//      initialData: '',
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          print('MAIN SCREEN VALUE ${snapshot.data}');
        } else {
          print('MAIN SCREEN ERROR VALUE ${snapshot.data}');
          print('MAIN SCREEN ERROR ${snapshot.error}');
        }

        return TextField(
          keyboardType: textInputType,
          inputFormatters: [
            LengthLimitingTextInputFormatter(inputFormatterLength),
          ],
          onChanged: (value) {
            print('CHANGED TEXT FIELD VALUE $value');
            changeFunction(value);
            print('SNAPSHOT DATA AFTER CHANGE FUNCTION ${snapshot.data}');
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
        print('12 years back ${DateTime.now().subtract(Duration(days: 4380))}');
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
                firstDate: DateTime(DateTime.now().year - 80, DateTime.now().month,DateTime.now().day),
                initialDate: currentValue ?? DateTime(DateTime.now().year - 12, DateTime.now().month,DateTime.now().day),
                lastDate: DateTime(DateTime.now().year - 12, DateTime.now().month,DateTime.now().day));
          },
          onChanged: (value) {
            sinkDateOfBirth(value);
          },
        );
      },
    );
  }

  // Cupertino style date picker
  //Issue: (In built keyboard pops up before the date picker is inflated)
  /*Widget _cupertinoDateOfBirthPicker(String labelText, Stream stream,
      Function sinkDateOfBirth, IconData iconData) {
    FocusNode _focusNode = new FocusNode();
    return StreamBuilder(
      stream: stream,
      initialData: '',
      builder: (context, snapshot) {
        return TextFormField(
          focusNode: _focusNode,
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
          onTap: () {
            _focusNode.unfocus();
            DatePicker.showDatePicker(
              context,
              pickerTheme: DateTimePickerTheme(
              showTitle: true,
                confirm: Text('custom Done', style: TextStyle(color: Colors.red)),
                cancel: Text('custom cancel', style: TextStyle(color: Colors.cyan)),
              ),
              minDateTime: DateTime.parse(MIN_DATETIME),
              maxDateTime: DateTime.parse(MAX_DATETIME),
              initialDateTime: DateTime.parse(INIT_DATETIME),
              dateFormat: 'yyyy-MMMM-dd',
              onChange: (dateTime, List<int> index) {
                print('CHANGED DATE ${dateTime.toString()}');
                sinkDateOfBirth(dateTime);
              },
            );
          },
        );
      },
    );
  }*/

  Widget _saveButton(String title, Stream stream) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 45,
          child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                print('FROM COMBINE LATEST ${snapshot.data}');
                return RaisedButton(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  color: Colors.green,
                  splashColor: Colors.white30,
                  onPressed: snapshot.hasData && snapshot.data != false && snapshot.data != null
                      ? () {

                        }
                      : null,
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
    _mainBloc.clearAllData();
    super.dispose();
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
