import 'package:flutter/material.dart';
import 'package:note/screens/palgaklist/detailscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class PalgakMemberDetailScreen extends StatelessWidget {
  final Member member;

  const PalgakMemberDetailScreen({Key? key, required this.member}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('멤버 상세 정보'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (member.imgUrl != null)
                  SizedBox(
                    width: 200,
                    height: 300,
                    child: Image.network(
                      member.imgUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'images/memberimage.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                Text(
                  '직책: ${member.clubPosition}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  '이름: ${member.mberName}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '소속: ${member.groupNm}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '업체명: ${member.companyNm}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '주소: ${member.Addr}',
                  style: TextStyle(fontSize: 20),
                ),
                GestureDetector(
                  onTap: () {
                    _launchCaller(member.mobile);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '휴대전화번호: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${member.mobile}',
                        style: TextStyle(
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchCaller(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await Permission.phone.request().isGranted) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      print('전화 권한이 필요합니다.');
    }
  }
}