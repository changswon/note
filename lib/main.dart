import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:note/screens/home/home.dart';
import 'package:note/screens/login/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'membernote',
      theme: ThemeData(
        // Your theme settings here
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _deviceSerialNumber = '';

  @override
  void initState() {
    super.initState();
    _getDeviceSerialNumber();
  }

  Future<void> _getDeviceSerialNumber() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    late String serialNumber;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      serialNumber = androidInfo.id;
    }

    setState(() {
      _deviceSerialNumber = serialNumber;
    });

    // API 호출
    _sendSerialNumberToApi(serialNumber);
  }

  Future<void> _sendSerialNumberToApi(String serialNumber) async {
    final apiUrl = 'http://ntpalgak.gananet.co.kr/api/login.php?&device_info=$serialNumber&check=DC';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String deviceValue = jsonResponse['device'];
        print('요청: $deviceValue');

        if (deviceValue == 'true') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        // API 호출 실패
        print('Failed to send serial number. Status code: ${response
            .statusCode}');
      }
    } catch (e) {
      print('Exception occurred while sending serial number: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
