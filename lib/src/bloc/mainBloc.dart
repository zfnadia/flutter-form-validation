import 'package:flutter_form_validation/src/bloc/blocProvider.dart';
import 'package:flutter_form_validation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends BlocBase with Validators {

//-------------------BehaviorSubjects-----------------------------------------
  final _username = BehaviorSubject<String>();
  final _isUsernameValid = BehaviorSubject<bool>();
  final _emailAddress = BehaviorSubject<String>();
  final _isEmailAddressValid = BehaviorSubject<bool>();
  final _dateOfBirth = BehaviorSubject<DateTime>();
  final _phoneNumber = BehaviorSubject<String>();
  final _address = BehaviorSubject<String>();
  final _aboutMe = BehaviorSubject<String>();

//-----------------------Stream-----------------------------------------------
//  Stream<String> get username => _username.stream.transform(validateUsername);
  Stream<String> get username => _username.stream;

  Stream<bool> get isUsernameValid => _isUsernameValid.stream;

/*  Stream<String> get emailAddress =>
      _emailAddress.stream.transform(validateEmailAddress);*/

  Stream<String> get emailAddress => _emailAddress.stream;

  Stream<bool> get isEmailAddressValid => _isEmailAddressValid.stream;

/*  Stream<DateTime> get dateOfBirth =>
      _dateOfBirth.stream.transform(validateDateOfBirth);*/

/*  Stream<String> get phoneNumber =>
      _phoneNumber.stream.transform(validatePhoneNumber);

  Stream<String> get address => _address.stream.transform(validateAddress);

  Stream<String> get aboutMe => _aboutMe.stream.transform(validateAboutMe);*/

/*  Stream<bool> get mandatoryFieldsChecked => Observable.combineLatest4(
      username, emailAddress, dateOfBirth, phoneNumber, (u, e, d, p) => true);*/

  Stream<bool> get mandatoryFieldsChecked => Observable.combineLatest2(
      isUsernameValid, isEmailAddressValid, (u, e) => true);

  //-----------------------Function---------------------------------------------
  void sinkUsername (String username) {
    int minLength = 4;
    int maxLength = 60;
    print('IN STREAM ${username.length}');
    if (username.length >= minLength && username.length <= maxLength) {
      _username.sink.add(username);
      _isUsernameValid.sink.add(true);
    }
    else {
      _username.sink.addError('Username should be between $minLength to $maxLength chareaters');
      _isUsernameValid.sink.add(false);
    }

  }

  void sinkEmailAddress (String emailAddress) {
    int minLength = 4;
    int maxLength = 60;
    print('IN STREAM ${emailAddress.length}');
    if (emailAddress.length >= minLength && emailAddress.length <= maxLength) {
      _emailAddress.sink.add(emailAddress);
      _isEmailAddressValid.sink.add(true);
    }
    else {
      _emailAddress.sink.addError('Email address should be between $minLength to $maxLength chareaters');
      _isEmailAddressValid.sink.add(false);
    }

  }

//  Function(String) get sinkUsername => _username.sink.add;

//  Function(String) get sinkEmailAddress => _emailAddress.sink.add;

  Function(DateTime) get sinkDateOfBirth => _dateOfBirth.sink.add;

  Function(String) get sinkPhoneNumber => _phoneNumber.sink.add;

  Function(String) get sinkAddress => _address.sink.add;

  Function(String) get sinkAboutMe => _aboutMe.sink.add;

  submit() {
    final validEmail = _emailAddress.value;
    final validPassword = _phoneNumber.value;

    print('Email is $validEmail, and password is $validPassword');
  }

  //----------------------------dispose-----------------------------------------
  @override
  void dispose() {
    _username.close();
    _isUsernameValid.close();
    _emailAddress.close();
    _isEmailAddressValid.close();
    _dateOfBirth.close();
    _phoneNumber.close();
    _address.close();
    _aboutMe.close();
  }

  void clearAllData() {
    _username.value = '';
    _isUsernameValid.value = false;
    _emailAddress.value = null;
    _isEmailAddressValid.value = false;
    _dateOfBirth.value = null;
    _phoneNumber.value = null;
    _address.value = null;
    _aboutMe.value = null;
  }
}
