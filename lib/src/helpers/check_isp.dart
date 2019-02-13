// import 'dart:convert';
// import 'package:http/http.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> checkIsp() async {
  // try {
  //   Response res = await get('http://ip-api.com/json/');
  //   Map data = jsonDecode(res.body);
  //   _registerDevice(data);
  //   return data['countryCode'] == 'IQ' || data['country'] == 'Iraq';
  // } catch (e) {
  //   print(e);
  //   return true;
  // }
  return true;
}

// void _registerDevice(data) {
//   Firestore.instance.collection('users_ip_info').add(data);
// }
