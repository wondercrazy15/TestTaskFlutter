class AddWishListRequestModel {

  final String name;
  final String image;
  final int price;
  final String code;
  final String url;

  AddWishListRequestModel({this.name, this.image, this.price, this.code, this.url});

  factory AddWishListRequestModel.fromJson(Map<String, dynamic> json) {
    return AddWishListRequestModel(
        name : json["name"],
        image : json["image"],
        price : json["price"],
        code : json["code"],
        url : json["url"],
    );
  }

}