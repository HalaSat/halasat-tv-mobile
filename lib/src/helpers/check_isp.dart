import 'dart:convert';
import 'package:http/http.dart';

Future<bool> checkIsp() async {
  Response res = await get('http://ip-api.com/json/');
  Map data = jsonDecode(res.body);
  return data['isp'] == 'HALASAT-LTD';
}
