import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class SearchResultDetailScreen extends StatelessWidget {
  final Member member;

  const SearchResultDetailScreen({Key? key, required this.member}) : super(key: key);

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
              border: Border.all(color: Colors.grey), // 테두리 스타일
              borderRadius: BorderRadius.circular(8), // 테두리 모서리 둥글기
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 이미지 표시
                if (member.imgUrl != null) // 이미지 URL이 존재하는 경우에만 표시
                  SizedBox(
                    width: 200,
                    height: 300,
                    child: Image.network(
                      member.imgUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // 이미지 로드 중 오류 발생 시 기본 이미지 표시
                        return Image.asset(
                          'images/memberimage.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16), // 이미지와 텍스트 간 간격 조정
                // 기존 텍스트 정보들
                SizedBox(height: 16), // 이미지와 텍스트 간 간격 조정
                Text(
                  '지구직책: ${member.zonePosition}',
                  style: TextStyle(fontSize: 25), // 글자 크기 조정
                ),
                Text(
                  '이름: ${member.mberName}',
                  style: TextStyle(fontSize: 20), // 글자 크기 조정
                ),
                Text(
                  '소속: ${member.groupNm}',
                  style: TextStyle(fontSize: 20), // 글자 크기 조정
                ),
                Text(
                  '업체명: ${member.companyNm}',
                  style: TextStyle(fontSize: 20), // 글자 크기 조정
                ),
                Text(
                  '주소: ${member.Addr}',
                  style: TextStyle(fontSize: 20), // 글자 크기 조정
                ),
                GestureDetector(
                  onTap: () {
                    _launchCaller(member.mobile); // 전화 걸기 함수 호출
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '휴대전화번호: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black, // 번호 이외의 텍스트 색상
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

class Member {
  final String mberId;
  final String mberName;
  final String groupNm;
  final String zonePosition;
  final String clubPosition;
  final String mobile;
  final String companyNm;
  final String Addr;
  final dynamic ordr;
  final String? imgUrl; // 추가된 이미지 URL 필드

  Member({
    required this.mberId,
    required this.mberName,
    required this.groupNm,
    required this.zonePosition,
    required this.clubPosition,
    required this.mobile,
    required this.companyNm,
    required this.Addr,
    required this.ordr,
    this.imgUrl, // 생성자에 이미지 URL 매개변수 추가
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      mberId: json['mber_id'],
      mberName: json['mber_name'],
      groupNm: json['group_nm'],
      zonePosition: json['zone_position']?? "",
      clubPosition: json['club_position'],
      mobile: json['mobile']?? "",
      companyNm: json['company_nm']?? "",
      Addr:json['addr'],
      ordr: json['ordr'],
      imgUrl: json['img_url']?? "", // 이미지 URL 매핑
    );
  }
}
