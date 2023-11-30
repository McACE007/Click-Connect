import 'package:flutter/material.dart';

const backGroundColor = Color.fromRGBO(0, 0, 0, 1.0);
const blueColor = Color.fromRGBO(0, 149, 246, 1.0);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromRGBO(97, 97, 97, 1.0);

Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHor(double width) {
  return SizedBox(
    width: width,
  );
}

EdgeInsets edgeInsetsTenTen() {
  return const EdgeInsets.symmetric(vertical: 10, horizontal: 10);
}

class FirebaseConstants {
  static const String usersCollection = "users";
  static const String postsCollection = "posts";
  static const String commentsCollection = "comments";
  static const String replaysCollection = "relays";
}
