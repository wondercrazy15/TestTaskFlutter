import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:testtask/Models/LoginRequestModel.dart';
import 'package:testtask/ViewModels/LoginViewModel.dart';
import 'package:testtask/Common/Globals.dart' as Globals;

import 'AddWishList.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  Widget addTextField(String placeHolder, TextEditingController txtContol, bool IsSecure) {

    return Container(
      margin: EdgeInsets.only(top: 15, right:20, left: 20),
      child: TextField(
        controller: txtContol,
        cursorColor: Colors.blueAccent,
        obscureText: IsSecure,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          color: Colors.blueAccent,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0),
          labelText: placeHolder,
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

  Widget getLoginButton(LoginViewModel model){

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          model.isBusy?'Logging In':'Login',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white)
                      ),
                      model.isBusy?Container(
                        margin: EdgeInsets.only(left: 20),
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ):Container(),
                    ],
                  )
                ),
              ),
              onTap: () async {
                //Mark as complete
                String email = txtEmailContoller.text.trim();
                String password = txtPasswordContoller.text;

                if(email.length == 0){
                  Globals.showToastMessage(context, "Please enter email");
                  return;
                }else if(!Globals.emailCheck.hasMatch(email)) {
                  Globals.showToastMessage(context, "Please enter proper email");
                  return;
                }else if(password.length == 0){
                  Globals.showToastMessage(context, "Please enter password");
                  return;
                }else if(password.length<8 || password.length>12 ){
                  Globals.showToastMessage(context, "Password must be 8-12 characters long");
                  return;
                }else{
                  LoginRequest request = LoginRequest(email: email, password: password);
                  model.setBusy(true);
                  try{
                    await model.Login(request);
                    final AppPreference = await SharedPreferences.getInstance();
                    model.setBusy(false);
                    setState(() {

                    });
                    AppPreference.setString(Globals.AppToken, model.response.token);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>AddWishListView()
                    ));
                  }catch(e){
                    Globals.showToastMessage(context, e.toString().replaceAll("Exception: ", ""));
                    model.setBusy(false);
                    setState(() {

                    });
                  }

                }
              },
            ),
          )
        ],

      ),
    );
  }

  final txtEmailContoller = TextEditingController();
  final txtPasswordContoller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    txtEmailContoller.dispose();
    txtPasswordContoller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    txtEmailContoller.text = "somebody2@email.com";
    txtPasswordContoller.text = "test!ng1";
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onModelReady: (model) => model.initial(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Login"),

            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  addTextField("Email", txtEmailContoller, false),
                  addTextField("Password", txtPasswordContoller, false),
                  getLoginButton(model)
//                  Text(
//                    '${model.isBusy ? 'Loading...' : model.counter}',
//                    style: Theme.of(context).textTheme.headline4,
//                  ),
//                  FloatingActionButton(
//                    onPressed: () => {
//                      model.incrementCounter(5)
//                    },
//                    tooltip: 'Increment',
//                    child: Icon(Icons.all_inclusive),
//                  )
                ],
              ),
          );
        });
  }
}
