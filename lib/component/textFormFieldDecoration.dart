import 'package:exchange/config/Color.dart';
import 'package:flutter/material.dart';


const textFormFieldInputDecoration = InputDecoration(
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: ColorCollections.royalBlue, width: 0.6),
    borderRadius: BorderRadius.all(Radius.circular(1.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorCollections.royalBlue, width: 0.6),
    borderRadius: BorderRadius.all(Radius.circular(1.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigoAccent, width: 0.6),
    borderRadius: BorderRadius.all(Radius.circular(1.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: ColorCollections.red, width: 0.6),
    borderRadius: BorderRadius.all(Radius.circular(1.0)),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.indigoAccent, width: 0.6),
    borderRadius: BorderRadius.all(Radius.circular(1.0)),
  ),
  filled: false,
  contentPadding: EdgeInsets.only(bottom: 0.0, left: 10.0, right: 10.0),
);
