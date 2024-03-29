import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Android Device ID: ${androidInfo.serialNumber}');
  }

  final info = await deviceInfo.deviceInfo;
  print('General Device Info: ${info.toMap()}');

  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _userMobile = '';

  Future<Map<String, dynamic>> checkMobileInApi(String mobile) async {
    // 기기 정보 가져오기
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String device_info = '${androidInfo.serialNumber}';
    final apiKey = '36l9njKiZB';
    final apiUrl =
        'https://hhicm.gananet.co.kr/build/api/phone_check.php?api_key=$apiKey&mobile=$mobile&device_info=$device_info';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('요청: ${response.body}');
        return Map<String, dynamic>.from(json.decode(response.body));
      } else {
        print('API 요청 실패: ${response.statusCode}');
        return {'result': 'failure'};
      }
    } catch (e) {
      print('API 요청 중 예외 발생: $e');
      return {'result': 'failure'};
    }
  }

//등록된 기기가 있을 때 다시 api 주고 받기
  void device_update(String mobile) async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String device_info = '${androidInfo.serialNumber}';

    final apiKey = '36l9njKiZB';
    final apiUrl =
        'https://hhicm.gananet.co.kr/build/api/phone_change.php?api_key=$apiKey&mobile=$mobile&device_info=$device_info';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('요청: ${response.body}');
        _navigateToWebView();
      } else {
        print('API 요청 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('API 요청 중 예외 발생: $e');

    }

  }

  void _showLoginResult(Map<String, dynamic> result) async {
    if (result['result'] == 'success') {
      if (result['already'] == 'Y') {
        String mobile_num = result['mobile_num'];
        // 이미 등록된 기기가 있을 때 처리
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("경고"),
              content: Text("이미 등록된 기기가 있습니다. 새롭게 등록하시겠습니까?"),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    final registerResult = await _registerDevice();
                    if (registerResult) {
                      //_navigateToWebView();
                      device_update(mobile_num);
                    } else {
                      print('기기 등록 실패');
                    }
                  },
                  child: Text("네"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: Text("아니오"),
                ),
              ],
            );
          },
        );
      } else {
        print('로그인 성공');
        _navigateToWebView();
      }
    } else {
      print('로그인 실패');
    }
  }

  Future<bool> _registerDevice() async {
    // 기기 등록 처리를 여기에 구현
    print('새로운 기기로 등록합니다.');
    return true; // 임시로 성공 상태 반환
  }

  void _navigateToWebView() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WebViewScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo2.png",
                height: 100,
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _userMobile = value;
                    });
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: '휴대폰 번호를 - 없이 입력하세요',
                    labelStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await checkMobileInApi(_userMobile);
                  _showLoginResult(result);
                },
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController _webViewController; // WebView 컨트롤러 선언

  @override
  Widget build(BuildContext context) {
    final Uri url = Uri.parse('https://hhicm.gananet.co.kr/build/index.php');

    return Scaffold(
      body: WillPopScope( // WillPopScope 추가
        onWillPop: () async {
          if (await _webViewController.canGoBack()) { // 웹뷰에서 뒤로 갈 수 있는지 확인
            _webViewController.goBack(); // 뒤로가기 수행
            return false; // 뒤로가기 수행되었으므로 이벤트 처리 완료
          } else {
            return true; // 웹뷰에서 뒤로 갈 수 없으면 앱 종료
          }
        },
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri.uri(url)),
          onWebViewCreated: (controller) {
            _webViewController = controller; // WebView 컨트롤러 할당
          },
        ),
      ),
    );
  }
}

