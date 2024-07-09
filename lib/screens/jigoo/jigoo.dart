import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:note/screens/jigoo/memberdetailscreen.dart';

Future<List<Member>> fetchMembers() async {
  final response = await http.get(Uri.parse('http://ntpalgak.gananet.co.kr/api/register.php?co_id=CON_00000001'));

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

class JigooScreen extends StatefulWidget {
  @override
  _JigooScreenState createState() => _JigooScreenState();
}

class _JigooScreenState extends State<JigooScreen> {
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
        title: Text(
          '지구임원단',
          style: TextStyle(
            fontFamily: 'Roboto', // 글꼴 변경
          ),
        ),
      ),
      backgroundColor: Colors.white, // 배경색 변경
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MemberDetailScreen(member: member)),
                    );
                  },
                  child: Card(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0),
                  ),
                    color: Colors.white,
                    elevation: 2, // 그림자 효과 추가
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 간격 조정
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          if (member.imgUrl != null)
                            SizedBox(
                              width: 100,
                              height: 130,
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
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (member.groupNm.isNotEmpty)
                                  Text(
                                    '소속: ${member.groupNm}',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic, // 글꼴 스타일 변경
                                    ),
                                  ),
                                if (member.zonePosition.isNotEmpty)
                                  Text(
                                    '지구직책: ${member.zonePosition}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue, // 글자 색상 변경
                                    ),
                                  ),
                                Text('이름:${member.mberName}'),
                                Text('업체명:${companyNm}'),
                                if (member.mobile.isNotEmpty)
                                  Text(
                                    '휴대전화번호: ${member.mobile}',
                                    style: TextStyle(
                                      color: Colors.green, // 글자 색상 변경
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "${snapshot.error}",
                style: TextStyle(
                  color: Colors.red, // 글자 색상 변경
                ),
              ),
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
    home: JigooScreen(),
  ));
}
