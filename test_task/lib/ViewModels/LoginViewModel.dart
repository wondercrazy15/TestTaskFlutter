import 'package:stacked/stacked.dart';
import 'package:testtask/Models/LoginRequestModel.dart';
import 'package:testtask/Models/LoginResponseModel.dart';
import 'package:testtask/services/webservice.dart';

class LoginViewModel extends BaseViewModel {

  LoginResponse _response;
  LoginResponse get response => _response;

  void initial() {
    //Login();
  }

  Future<void> Login(LoginRequest request) async {
    setBusy(true);

    final results =  await Webservice().login(request);

    this._response = results;

    setBusy(false);
    notifyListeners();

  }
}
