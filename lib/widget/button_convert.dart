import 'package:flutter/material.dart';
import 'package:pratica5/utils/AppSettings.dart';

Container _btnConvert(Size size) {
  return Container(
    width: size.width * 0.5,
    height: size.height * 0.08,
    decoration: BoxDecoration(
        color: AppSettings.colorPrimaryFont,
        borderRadius: BorderRadius.circular(20)),
    child: Center(
        child: Text(
      'Convert'.toUpperCase(),
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppSettings.colorPrimary),
    )),
  );
}
