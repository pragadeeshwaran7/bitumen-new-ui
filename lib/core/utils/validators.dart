//Email/phone/OTP input validators

class Validators {
  static bool isEmail(String email) => email.contains("@");
  static bool isPhone(String phone) => phone.length == 10;
}
