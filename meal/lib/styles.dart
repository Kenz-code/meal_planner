import 'package:flutter/material.dart';
import 'package:meal/colors.dart';

const TextStyle headingStyle = TextStyle(
  fontFamily: "OpenSans",
  fontSize: 28,
  fontWeight: FontWeight.w400
);
const TextStyle displayStyle = TextStyle(
    fontFamily: "OpenSans",
    fontSize: 40,
    fontWeight: FontWeight.w500
);
const TextStyle bodyStyle = TextStyle(
  fontFamily: "OpenSans",
  fontSize: 16,
  fontWeight: FontWeight.w400,
);
const TextStyle labelStyle = TextStyle(
  fontFamily: "OpenSans",
  fontSize: 14,
  fontWeight: FontWeight.w400,
);
const TextStyle titleStyle = TextStyle(
  fontFamily: "OpenSans",
  fontSize: 22,
  fontWeight: FontWeight.w500,
);
const BorderRadius borderRadius = BorderRadius.all(Radius.circular(10));
BorderSide neutralBorder = BorderSide(color: neutral200, width: 2.0);
BorderSide neutralBorderDark = BorderSide(color: neutral600, width: 2.0);
BorderSide primaryBorder = BorderSide(color: primary600, width: 2.0);
BorderSide primaryBorderDark = BorderSide(color: primary300, width: 2.0);
BorderSide secondBorder = BorderSide(color: second600, width: 2.0);
const double bigElevation = 10;
const double smallElevation = 5;