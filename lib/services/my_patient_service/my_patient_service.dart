import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:vaidraj/models/my_patients_model.dart';
import '../../utils/api_helper/api_helper.dart';
import '../../utils/http_helper/http_helper.dart';

class MyPatientService {
  Future<MyPatientsModel?> getPatients({required BuildContext context}) async {
    try {
      Response response = await HttpHelper.get(
        context: context,
        uri: ApiHelper.getHomeScreenVideo,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          MyPatientsModel model = MyPatientsModel.fromJson(data);
          return model;
        }
      }
      return null;
    } catch (e) {
      print("error while getting Patients => $e");
      return null;
    }
  }
}
