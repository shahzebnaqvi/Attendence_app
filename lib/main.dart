import 'dart:io';
import 'package:attendence/home.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/services.dart';
import 'package:mac_address/mac_address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}

final TextEditingController phone_controller = TextEditingController();
var phonenum = '';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: Text(
                "Attendence System",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Textinput(context, Colors.blue, Colors.grey[100], Colors.blue,
                'Enter Mobile Number', phone_controller, Icon(Icons.phone)),
            // TextField(
            //   controller: phone_controller,
            // ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    onPressed: () {
                      phonenum = phone_controller.text;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(phone: phonenum)));
                    },
                    child: Text('Login')))
          ],
        ),
      ),
    ));
  }
}

TextField Textinput(BuildContext context, textFieldfont, textFieldback,
    fontSecondary, hinttext, controller_field, Icon prefixiconname) {
  var theme = Theme.of(context).textTheme;
  return TextField(
    keyboardType: TextInputType.phone,
    controller: controller_field,
    style: theme.bodyText1!.copyWith(
        color: textFieldfont,
        // fontSize: MediaQuery.of(context).size.height * 0.02,
        fontSize: 13,
        fontWeight: FontWeight.w500),
    decoration: InputDecoration(
        prefixIcon: prefixiconname,
        focusColor: Colors.blue,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: textFieldback,
        // border: UnderlineInputBorder(borderSide: BorderSide.none),
        hintText: hinttext,
        contentPadding: EdgeInsets.all(15),
        hintStyle: theme.bodyText2!.copyWith(
            color: fontSecondary,
            // fontSize: MediaQuery.of(context).size.height * 0.032,
            fontSize: 13,
            fontWeight: FontWeight.w500)),
  );
}
