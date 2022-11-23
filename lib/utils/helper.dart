import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double defaultPadding = 24.0;

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

String convertTimeStampToDateTimeString(Timestamp value) {
  final dateTime = value.toDate();
  return DateFormat('dd MMM yyyy').format(dateTime);
}