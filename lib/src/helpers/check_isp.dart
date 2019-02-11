import 'dart:convert';
import 'package:http/http.dart';

Future<bool> checkIsp() async {
  Response res = await get('http://ip-api.com/json/');
  Map data = jsonDecode(res.body);
  // return false;
  return data['isp'] == 'Hala Al Rafidain Telecom Ltd' ||
      data['isp'] == 'HALASAT-LTD';
}
