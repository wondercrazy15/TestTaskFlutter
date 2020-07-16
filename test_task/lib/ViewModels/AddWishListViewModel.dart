import 'package:stacked/stacked.dart';
import 'package:testtask/Models/AddWishListRequestModel.dart';
import 'package:testtask/Models/AddWishListResponseModel.dart';
import 'package:testtask/Models/LoginRequestModel.dart';
import 'package:testtask/Models/LoginResponseModel.dart';
import 'package:testtask/services/webservice.dart';

class AddWishListViewModel extends BaseViewModel {

  AddWishListResponseModel _response;
  AddWishListResponseModel get response => _response;

  void initial() {

  }

  Future<void> AddWishList(AddWishListRequestModel request) async {
    setBusy(true);

    final results =  await Webservice().addWishList(request);

    this._response = results;

    setBusy(false);
    notifyListeners();

  }
}
