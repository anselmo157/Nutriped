import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nutriped/app/data/models/food_model.dart';

class PatientController {
  List<FoodModel> meal = [];

  Future<bool> sendMeal({required DateTime time}) async {
    try {
      String? deviceID;

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfo.androidInfo;
        deviceID = androidInfo.id;
      }

      if (Platform.isIOS) {
        var iosInfo = await deviceInfo.iosInfo;
        deviceID = iosInfo.identifierForVendor!;
      }

      if (deviceID != null) {
        deviceID = deviceID.replaceAll('.', '');
      }

      final reference = FirebaseDatabase.instance.ref().child(
            'patients/$deviceID',
          );

      final snapshot = await reference.get();
      var data = jsonEncode(snapshot.value);
      Map<String, dynamic> map = jsonDecode(data);

      if (map['meals'] != null) {
        List<dynamic> list = map['meals'];

        Map<String, dynamic> aux = {};

        for (FoodModel item in meal) {
          aux[item.name] = item.sugarType?.value ??
              item.fillingType?.value ??
              item.dietType?.value;
        }

        list.add(
          {
            'foods': aux,
            'date': time.toIso8601String(),
          },
        );

        reference.update({
          'meals': list,
        });
      } else {
        Map<String, dynamic> map = {};

        for (FoodModel item in meal) {
          map[item.name] = item.sugarType?.value ??
              item.fillingType?.value ??
              item.dietType?.value;
        }

        reference.update({
          'meals': [
            {
              'foods': map,
              'date': time.toIso8601String(),
            },
          ],
        });
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
  }) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = initialDate.subtract(const Duration(days: 365 * 100));
    DateTime lastDate = DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? null
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
