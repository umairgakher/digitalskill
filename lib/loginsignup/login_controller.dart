// ignore_for_file: camel_case_types, empty_constructor_bodies

class loginController {
  static final loginController _session = loginController._internal();
  String? checkuser;
  // List<String> user;

  factory loginController() {
    return _session;
  }

  loginController._internal();
  // : user = [];
}
