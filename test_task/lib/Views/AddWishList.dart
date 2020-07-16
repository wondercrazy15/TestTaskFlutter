import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:testtask/Models/AddWishListRequestModel.dart';
import 'package:testtask/ViewModels/AddWishListViewModel.dart';
import 'package:testtask/Common/Globals.dart' as Globals;

class AddWishListView extends StatefulWidget {
  @override
  _AddWishListViewState createState() => _AddWishListViewState();
}

class _AddWishListViewState extends State<AddWishListView> {

  Widget addTextField(String placeHolder, TextEditingController txtContol, bool IsNumeric) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 15, right:20, left: 20),
      child: TextField(
        controller: txtContol,
        cursorColor: Colors.blueAccent,
        keyboardType: IsNumeric?TextInputType.number:TextInputType.text,
        obscureText: false,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          color: Colors.blueAccent,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
          labelText: placeHolder,
          isDense: true,
//          border: InputBorder.none,

          labelStyle: TextStyle(
            color: Colors.blueAccent,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
                color: Colors.blueAccent,
                width: 2.0
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget getSubmitButton(AddWishListViewModel model){
    return Container(
      height: 55,
      width: double.infinity,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(27.5),
            topRight: Radius.circular(27.5),
            bottomLeft: Radius.circular(27.5),
            bottomRight: Radius.circular(27.5)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                      'Submit',
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white)
                  ),
                ),
              ),
              onTap: () async {
                //Mark as complete
                String name = txtNameController.text;
                String image = txtImageController.text;
                String price = txtPriceController.text;
                String code = txtCodeController.text;
                String url = txtUrlController.text;

                if(name.length == 0){
                  Globals.showToastMessage(context, "Please enter name");
                  return;
                }else if(image.length == 0) {
                  Globals.showToastMessage(context, "Please enter image url");
                  return;
                }else if(price.length == 0){
                  Globals.showToastMessage(context, "Please enter price");
                  return;
                }else if(int.parse(price) == null){
                  Globals.showToastMessage(context, "Please enter proper price");
                  return;
                }else if(int.parse(price) == 0){
                  Globals.showToastMessage(context, "Price cannot be 0");
                  return;
                }else if(code.length == 0 ){
                  Globals.showToastMessage(context, "Please enter code");
                  return;
                }else if(url.length == 0 ){
                  Globals.showToastMessage(context, "Please enter product url");
                  return;
                }else{
                  AddWishListRequestModel request = AddWishListRequestModel(
                      name: name,
                      image: image,
                      price: int.parse(price),
                      code: code,
                      url: url,
                  );
                  try{
                    await model.AddWishList(request);
                    setState(() async {
                      print(model.response);
                      loadEmpty();
                      setState(() {

                      });
                    });
                  }catch(e){
                    Globals.showToastMessage(context, e.toString().replaceAll("Exception: ", ""));
                  }

                }
              },
            ),
          )
        ],

      ),
    );
  }

  final txtNameController = TextEditingController();
  final txtImageController = TextEditingController();
  final txtPriceController = TextEditingController();
  final txtCodeController = TextEditingController();
  final txtUrlController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    txtNameController.dispose();
    txtImageController.dispose();
    txtPriceController.dispose();
    txtCodeController.dispose();
    txtUrlController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEmpty();
  }

  loadEmpty(){
    txtNameController.text = "";
    txtImageController.text = "";
    txtPriceController.text = "";
    txtCodeController.text = "";
    txtUrlController.text = "";
  }

//  PickedFile _image;
//  File _image;
//  String imageBase64 = "";
//
//  Future getImage() async
//  {
//    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    _image = image;
//    final bytes = Io.File(image.path).readAsBytesSync();
//    String img64 = base64Encode(bytes);
//    imageBase64 = img64;
//
//    setState(() {
//
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddWishListViewModel>.reactive(
        viewModelBuilder: () => AddWishListViewModel(),
        onModelReady: (model) => model.initial(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Add Wishlist"),
              //SingleChildScrollView
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                addTextField("Name", txtNameController, false),
                addTextField("Image Url", txtImageController, false),
                addTextField("Price", txtPriceController, true),
                addTextField("Code", txtCodeController, false),
                addTextField("Url", txtUrlController, false),
                getSubmitButton(model)
              ],
            ),
          );
        });
  }
}
