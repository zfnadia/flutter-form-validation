import 'dart:async';

class Validators {
  final validateUsername = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    int minLength = 2;
    int maxLength = 60;
    if (username.length > minLength && username.length < maxLength)
      sink.add(username);
     else
      sink.addError('Username should be between $minLength to $maxLength chareaters');
  });

  final validateEmailAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (emailAddress, sink) {
    bool isEmailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailAddress);
    if (isEmailValid)
      sink.add(emailAddress);
    else
      sink.addError('Email is not valid!');
  });

  final validateDateOfBirth = StreamTransformer<DateTime, DateTime>.fromHandlers(
    handleData: (dateOfBirth, sink) {
      sink.add(dateOfBirth);
    }
  );

  final validatePhoneNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (phoneNumber, sink) {
    bool isPhoneNumValid =
        RegExp(r"^(?:\+88|01)?\d{11}$").hasMatch(phoneNumber);
    if (isPhoneNumValid)
      sink.add(phoneNumber);
    else
      sink.addError('Phone number is not valid!');
  });

  final validateAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (address, sink) {
    int minLength = 4;
    int maxLength = 100;
    if (address.length >= minLength && address.length <= maxLength)
      sink.add(address);
    else
      sink.addError('Address should be between $minLength to $maxLength characters');
  });

  final validateAboutMe = StreamTransformer<String, String>.fromHandlers(
      handleData: (aboutMe, sink) {
    int minLength = 4;
    int maxLength = 150;
    if (aboutMe.length >= minLength && aboutMe.length <= maxLength)
      sink.add(aboutMe);
    else
      sink.addError('Details should be between $minLength to $maxLength characters');
  });

  calculateAge(DateTime birthDate) {
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
}
