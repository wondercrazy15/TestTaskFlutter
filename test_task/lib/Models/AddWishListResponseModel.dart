class AddWishListResponseModel {

  final String message;

  AddWishListResponseModel({this.message});

  factory AddWishListResponseModel.fromJson(Map<String, dynamic> json) {
    return AddWishListResponseModel(
      message: json["message"],
    );
  }

}