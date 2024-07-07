import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sample_app/Controllers/LoginScreenController.dart';
import 'package:sample_app/Views/HomeScreen.dart';
import 'package:sample_app/Views/PhoneNumber.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//API CALLL
void login(String email, password) async {
  try {
    final response =
        await http.post(Uri.parse("https://reqres.in/api/login"), body: {
      'email': email,
      'password': password,
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      Get.to(HomeScreen());
      print(data.toString());
      print("Account created successfully");
    } else {
      print('Failed');
    }
  } catch (e) {
    print(e.toString());
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 12.h, right: 7.w, left: 7.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade700,
                  highlightColor: Colors.grey.shade100,
                  child: Text(
                    "Login Screen",
                    style:
                        TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
                  ),
                ),
              ]),
              SizedBox(
                height: 0.5.h,
              ),
              Row(
                children: [
                  Text(
                    "Enter Login Details",
                    style:
                        TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              getCustomeFormFields(
                  controller.emailCtr, "Enter Email Address", 1),
              SizedBox(
                height: 1.h,
              ),
              getCustomeFormFields(controller.passCtr, "Enter Password", 2),
              SizedBox(
                height: 1.h,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(const PhoneNumber());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password ?"),
                  ],
                ),
              ),
              SizedBox(
                height: 7.h,
              ),
              GestureDetector(
                onTap: () {
                  login(controller.emailCtr.text.toString(),
                      controller.passCtr.text.toString());
                },
                child: Container(
                  height: 6.h,
                  alignment: Alignment.center,
                  width: SizerUtil.width / 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blue,
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ),
              // FadeInUp(
              //     from: 50,
              //     child: Obx(() {
              //       return getformButton(() {
              //         if (controller.isFormInvalidate.value == true) {
              //           Get.to(const HomeScreen());
              //         }
              //       }, "LOgin", validate: controller.isFormInvalidate.value);
              //     })),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCustomeFormFields(
      TextEditingController? controllers, String hint, int index) {
    return TextFormField(
      controller: controllers,
      style: TextStyle(fontSize: 10.sp),
      keyboardType:
          index == 1 ? TextInputType.emailAddress : TextInputType.text,
      obscureText: index == 2 ? controller.obsecureText.value : false,
      onChanged: (value) {
        if (index == 1) {
          controller.validateEmail(value);
        } else {
          controller.validatePassword(value);
        }
      },
      decoration: InputDecoration(
        errorText: index == 1
            ? controller.emailModel.value.error
            : controller.passModel.value.error,
        hintText: hint,
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              index == 1 ? Icons.email : Icons.password_rounded,
              // color: primaryColor,
            ),
            SizedBox(
              width: 3.w,
            ),
            Container(
              color: Colors.grey,
              width: 0.5.w,
              height: 3.5.h,
            ),
            SizedBox(
              width: 2.w,
            ),
          ],
        ),
        suffixIcon: index == 2
            ? GestureDetector(
                onTap: () {
                  controller.obsecureText.value =
                      !controller.obsecureText.value;
                  setState(() {});
                },
                child: Icon(
                  controller.obsecureText.value == true
                      ? Icons.visibility_off
                      : Icons.visibility,
                  // color: primaryColor,
                ),
              )
            : null,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return index == 1 ? "Enter Email Address" : "Enter Password";
        }
        return null;
      },
    );
  }
}
