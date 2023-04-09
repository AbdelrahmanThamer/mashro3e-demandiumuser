import 'package:flutter/material.dart';
import 'package:get/get.dart';

const ubuntuLight = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w300,
);


const ubuntuRegular = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w400,
);

const ubuntuMedium = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w500,
);

const ubuntuBold = TextStyle(
  fontFamily: 'Ubuntu',
  fontWeight: FontWeight.w700,
);

List<BoxShadow>? searchBoxShadow = Get.isDarkMode ? null : [BoxShadow(
    offset: Offset(0,3),
    color: Color(0x208F94FB), blurRadius: 5, spreadRadius: 2)];

//card boxShadow
 List<BoxShadow>? cardShadow = Get.isDarkMode? null:[BoxShadow(
   offset: Offset(0, 1),
   blurRadius: 2,
   color: Colors.black.withOpacity(0.15),
 )];


List<BoxShadow>? shadow = Get.isDarkMode ? [BoxShadow(
    offset: Offset(0,3),
    color: Colors.grey[100]!, blurRadius: 1, spreadRadius: 2)] : [BoxShadow(
    offset: Offset(0,3),
    color: Colors.grey[100]!, blurRadius: 1, spreadRadius: 2)];