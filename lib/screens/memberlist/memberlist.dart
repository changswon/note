import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Member>> fetchMembers() async {
  final response = await http.get(Uri.parse('http://ntpalgak.gananet.co.kr/api/member.php?co_id=CON_00000002'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<Member> members = [];

    if (data.containsKey('total')) {
      int total = int.parse(data['total']);

      for (int i = 0; i < total; i++) {
        if (data.containsKey('member') && data['member'][i] != null) {
          members.add(Member.fromJson(data['member'][i] as Map<String, dynamic>));
        }
      }

      return members;
    } else {
      throw Exception('Unexpected response format');
    }
  } else {
    throw Exception('Failed to load members');
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
  final dynamic ordr;
  final String? imgUrl; // 추가된 이미지 URL 필드
  final String? imgName;


  Member({
    required this.mberId,
    required this.mberName,
    required this.groupNm,
    required this.zonePosition,
    required this.clubPosition,
    required this.mobile,
    required this.companyNm,
    required this.ordr,
    this.imgUrl, // 생성자에 이미지 URL 매개변수 추가
    required this.imgName,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      mberId: json['mber_id'],
      mberName: json['mber_name'],
      groupNm: json['group_nm'],
      zonePosition: json['zone_position']?? "",
      clubPosition: json['club_position']?? "",
      mobile: json['mobile']?? "",
      companyNm: json['company_nm']?? "",
      ordr: json['ordr'],
      imgUrl: json['img_url'],
      imgName: json['img_name'] ?? "", // null 체크 추가
    );
  }
}

class MemberListScreen extends StatefulWidget {
  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late Future<List<Member>> _members;

  @override
  void initState() {
    super.initState();
    _members = fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('전체 연락처'),
      ),
      body: FutureBuilder<List<Member>>(
        future: _members,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Member member = snapshot.data![index];
                String companyNm = member.companyNm;
                if (companyNm.length > 10) {
                  companyNm = companyNm.substring(0, 10) + "...";
                }
                return ListTile(
                  title: Row(
                    children: [
                      if (member.imgUrl != null)
                        SizedBox(
                          width: 100, // 이미지 너비 조정
                          height: 130, // 이미지 높이 조정
                          child: Image.network(
                            member.imgUrl!,
                            fit: BoxFit.cover, // 이미지가 컨테이너에 맞게 조절되도록 함
                            errorBuilder: (context, error, stackTrace) {
                              // 이미지 로드 중 오류가 발생했을 때 기본 이미지를 대신 표시합니다.
                              return Image.asset(
                                'images/memberimage.png', // 기본 이미지의 경로
                                fit: BoxFit.cover, // 이미지가 컨테이너에 맞게 조절되도록 함
                              );
                            },
                          ),
                        ),
                      SizedBox(width: 16), // 이미지와 텍스트 간 간격 조정
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (member.zonePosition.isNotEmpty) Text('지구직책: ${member.zonePosition}'),
                          if (member.groupNm.isNotEmpty) Text('소속: ${member.groupNm}'),
                          Text('이름:${member.mberName}'),
                          Text('업체명:${member.companyNm}'),
                          if (member.clubPosition.isNotEmpty) Text('클럽직책: ${member.clubPosition}'),
                          if (member.mobile.isNotEmpty) Text('휴대전화번호: ${member.mobile}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MemberListScreen(),
  ));
}
