import 'package:flutter_form_validation/src/bloc/blocProvider.dart';
import 'package:flutter_form_validation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends BlocBase with Validators {
//-------------------BehaviorSubjects-----------------------------------------

  final _username = BehaviorSubject<String>();
  final _emailAddress = BehaviorSubject<String>();
  final _dateOfBirth = BehaviorSubject<DateTime>();
  final _phoneNumber = BehaviorSubject<String>();
  final _address = BehaviorSubject<String>();
  final _aboutMe = BehaviorSubject<String>();

//-----------------------Stream-----------------------------------------------
  Stream<String> get username => _username.stream.transform(validateUsername);

  Stream<String> get emailAddress =>
      _emailAddress.stream.transform(validateEmailAddress);

  Stream<DateTime> get dateOfBirth =>
      _dateOfBirth.stream.transform(validateDateOfBirth);

  Stream<String> get phoneNumber =>
      _phoneNumber.stream.transform(validatePhoneNumber);

  Stream<String> get address => _address.stream.transform(validateAddress);

  Stream<String> get aboutMe => _aboutMe.stream.transform(validateAboutMe);

/*
  Stream<bool> get userDataValid => Observable.combineLatest3(
      username, emailAddress, phoneNumber, (u, e, p) => true);
*/

  //-----------------------Function---------------------------------------------

  Function(String) get sinkUsername => _username.sink.add;

  Function(String) get sinkEmailAddress => _emailAddress.sink.add;

  Function(DateTime) get sinkDateOfBirth => _dateOfBirth.sink.add;

  Function(String) get sinkPhoneNumber => _phoneNumber.sink.add;

  Function(String) get sinkAddress => _address.sink.add;

  Function(String) get sinkAboutMe => _aboutMe.sink.add;

  //----------------------------dispose-----------------------------------------

  @override
  void dispose() {
    _username.close();
    _emailAddress.close();
    _dateOfBirth.close();
    _phoneNumber.close();
    _address.close();
    _aboutMe.close();
  }

  void clearAllData() {
    _username.value = null;
    _emailAddress.value = null;
    _dateOfBirth.value = null;
    _phoneNumber.value = null;
    _address.value = null;
    _aboutMe.value = null;
  }
}
