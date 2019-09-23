import 'package:flutter_form_validation/src/bloc/blocProvider.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends BlocBase {
//-------------------BehaviorSubjects-----------------------------------------
  final _username = BehaviorSubject<String>();
  final _isUsernameValid = BehaviorSubject<bool>();
  final _emailAddress = BehaviorSubject<String>();
  final _isEmailAddressValid = BehaviorSubject<bool>();
  final _dateOfBirth = BehaviorSubject<DateTime>();
  final _isDateOfBirthValid = BehaviorSubject<bool>();
  final _phoneNumber = BehaviorSubject<String>();
  final _isPhoneNumberValid = BehaviorSubject<bool>();
  final _address = BehaviorSubject<String>();
  final _aboutMe = BehaviorSubject<String>();

//-----------------------Stream-----------------------------------------------
  Stream<String> get username => _username.stream;

  Stream<String> get emailAddress => _emailAddress.stream;

  Stream<DateTime> get dateOfBirth => _dateOfBirth.stream;

  Stream<String> get phoneNumber => _phoneNumber.stream;

  Stream<String> get address => _address.stream;

  Stream<String> get aboutMe => _aboutMe.stream;

  Stream<bool> get mandatoryFieldsChecked => Observable.combineLatest4(
          _isUsernameValid,
          _isEmailAddressValid,
          _isDateOfBirthValid,
          _isPhoneNumberValid, (u, e, d, p) {
        if (_isUsernameValid.value &&
            _isEmailAddressValid.value &&
            _isDateOfBirthValid.value &&
            _isPhoneNumberValid.value) {
          return true;
        } else {
          return false;
        }
      });

//We can not use this as only combining streams here always returns true.
/*
  Stream<bool> get mandatoryFieldsChecked => Observable.combineLatest2(
      isUsernameValid, isEmailAddressValid, (u, e) => true);
*/

  //-----------------------Function---------------------------------------------
  void sinkUsername(String username) {
    int minLength = 4;
    int maxLength = 60;
    print('IN STREAM ${username.length}');
    if (username.length >= minLength && username.length <= maxLength) {
      _username.sink.add(username);
      _isUsernameValid.sink.add(true);
    } else {
      _username.sink.addError(
          'Username should be between $minLength to $maxLength chareaters');
      _isUsernameValid.sink.add(false);
    }
  }

  void sinkEmailAddress(String emailAddress) {
    bool isEmailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailAddress);
    if (isEmailValid) {
      _emailAddress.sink.add(emailAddress);
      _isEmailAddressValid.sink.add(true);
    } else {
      _emailAddress.sink.addError('Email is not valid!');
      _isEmailAddressValid.sink.add(false);
    }
  }

  void sinkDateOfBirth(DateTime dateOfBirth) {
    int minAge = 12;
    int maxAge = 80;
    int age = calculateAge(dateOfBirth);
    print('Age $age');
    if (age >= minAge && age <= maxAge) {
      _dateOfBirth.sink.add(dateOfBirth);
      _isDateOfBirthValid.sink.add(true);
    } else {
      _dateOfBirth.sink
          .addError('Age should be between $minAge to $maxAge years');
      _isDateOfBirthValid.sink.add(false);
    }
  }

  void sinkPhoneNumber(String phoneNumber) {
    bool isPhoneNumValid =
        RegExp(r"^(?:\+?88)?01[3-9]\d{8}$").hasMatch(phoneNumber);
    if (isPhoneNumValid && phoneNumber.length != null) {
      _phoneNumber.sink.add(phoneNumber);
      _isPhoneNumberValid.sink.add(true);
    } else {
      _phoneNumber.sink.addError('Phone number is not valid!');
      _isPhoneNumberValid.sink.add(false);
    }
  }

  void sinkAddress(String address) {
    int minLength = 4;
    int maxLength = 100;
    if ((address.length >= minLength && address.length <= maxLength) || address.length == 0)
      _address.sink.add(address);
    else
      _address.sink.addError(
          'Address should be between $minLength to $maxLength characters');
  }

  void sinkAboutMe(String aboutMe) {
    int minLength = 4;
    int maxLength = 150;
    if ((aboutMe.length >= minLength && aboutMe.length <= maxLength) || aboutMe.length == 0)
      _aboutMe.sink.add(aboutMe);
    else
      _aboutMe.sink.addError(
          'Details should be between $minLength to $maxLength characters');
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  //----------------------------dispose-----------------------------------------
  @override
  void dispose() {
    _username.close();
    _isUsernameValid.close();
    _emailAddress.close();
    _isEmailAddressValid.close();
    _dateOfBirth.close();
    _isDateOfBirthValid.close();
    _phoneNumber.close();
    _isPhoneNumberValid.close();
    _address.close();
    _aboutMe.close();
  }

  void clearAllData() {
    _username.value = '';
    _isUsernameValid.value = false;
    _emailAddress.value = null;
    _isEmailAddressValid.value = false;
    _dateOfBirth.value = null;
    _isDateOfBirthValid.value = false;
    _phoneNumber.value = null;
    _isPhoneNumberValid.value = null;
    _address.value = null;
    _aboutMe.value = null;
  }
}
