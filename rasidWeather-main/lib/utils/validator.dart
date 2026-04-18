
extension EmailValidator on String {
  String? validEmail() {
    final RegExp regex =  RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if(isEmpty) {
      return 'Please enter email';
    } else {
      if (!regex.hasMatch(this)) {
        return 'Enter valid email';
      } else {
        return null;
      }
    }
  }
}

extension PasswordValidator on String {
  String? validPassword() {
    // RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (isEmpty) {
      return 'الرجاء إدخال كلمة المرور';
    } else {
      if (length < 8) {
        return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
      // if (!regex.hasMatch(this)) {
      //   return '1 upperCase, 1 lowerCase, 1 number and 1 character';
      } else {
        return null;
      }
    }
  }
}

// confirmPassword validator
extension ConfirmPasswordValidator on String {
  String? validConfirmPassword(String password) {
    if (isEmpty) {
      return 'الرجاء تأكيد كلمة المرور';
    } else {
      if (this != password) {
        return 'كلمة المرور غير متطابقة';
      } else {
        return null;
      }
    }
  }
}

extension PhoneNumberValidator on String {
  String? isValidPhoneNumber() {
    final RegExp regex = RegExp(r'^[0-9]{10}$');
    if (isEmpty) {
      return 'Please enter phone number';
    } else {
      if (!regex.hasMatch(this)) {
        return 'Enter valid phone number';
      } else {
        return null;
      }
    }
  }
}


extension NameValidator on String {
  String? isValidName() {
    final RegExp regex = RegExp(r'^[a-zA-Z ]{2,30}$');
    if (isEmpty) {
      return 'Please enter name';
    } else {
      if (!regex.hasMatch(this)) {
        return 'Enter valid name';
      } else {
        return null;
      }
    }
  }
}

extension BioValidator on String {
  String? isValidBio() {
    // regex for bio contains emojis and special characters also text , numbers
    final RegExp regex = RegExp(r'^[a-zA-Z0-9\W ]{2,100}$');
    // RegExp regex = RegExp(r'^[a-zA-Z0-9 ]{2,100}$');
    if (isEmpty) {
      return 'Please enter bio';
    } else {
      if (!regex.hasMatch(this)) {
        return 'Enter valid bio';
      } else {
        return null;
      }
    }
  }
}

extension AddressValidator on String {
  String? isValidAddress() {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9 ]{2,100}$');
    if (isEmpty) {
      return 'Please enter address';
    } else {
      if (!regex.hasMatch(this)) {
        return 'Enter valid address';
      } else {
        return null;
      }
    }
  }
}

extension PinCodeValidator on String {
  String? validPinCode() {
    final RegExp regex = RegExp(r'^[0-9]{6}$');
    if (isEmpty) {
      return 'Please enter pin code';
    } else {
      if (!regex.hasMatch(this)) {
        return 'Enter valid pin code';
      } else {
        return null;
      }
    }
  }
}
