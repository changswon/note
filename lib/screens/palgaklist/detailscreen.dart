import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:note/screens/palgaklist/palgakmemberdetailscreen.dart';

class Member {
  final String mberId;
  final String mberName;
  final String groupNm;
  final String zonePosition;
  final String clubPosition;
  final String mobile;
  final String companyNm;
  final dynamic ordr;
  final String Addr;
  final String? imgUrl;
  final String? imgName;

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
    this.imgUrl,
    this.imgName,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      mberId: json['mber_id'],
      mberName: json['mber_name'],
      groupNm: json['group_nm'],
      zonePosition: json['zone_position'] ?? '',
      clubPosition: json['club_position'] ?? '',
      mobile: json['mobile'] ?? '',
      companyNm: json['company_nm'] ?? '',
      Addr:json['addr'],
      ordr: json['ordr'],
      imgUrl: json['img_url'],
      imgName: json['img_name'] ?? '',
    );
  }
}

class DetailScreen extends StatefulWidget {
  final String coId; // coId로 변경
  final String coSubject;

  DetailScreen({required this.coId, required this.coSubject}); // 생성자 매개변수도 coId로 변경

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<List<Member>> _memberList;

  @override
  void initState() {
    super.initState();
    _memberList = fetchMemberList();
  }

  Future<List<Member>> fetchMemberList() async {
    final response = await http.get(Uri.parse('http://ntpalgak.gananet.co.kr/api/register.php?co_id=${widget.coId}')); // coId 사용

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);

      if (data is Map && data.containsKey('member')) {
        final List<dynamic> memberData = data['member'];
        List<Member> memberList = [];

        for (int i = 0; i < memberData.length; i++) {
          memberList.add(Member.fromJson(memberData[i] as Map<String, dynamic>));
        }

        return memberList;
      } else {
        throw Exception('Invalid response format: expected a map with a "member" key');
      }
    } else {
      throw Exception('Failed to load member list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.coSubject}'), // coId로 변경
      ),
      body: FutureBuilder<List<Member>>(
        future: _memberList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
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
                      MaterialPageRoute(builder: (context) => PalgakMemberDetailScreen(member: member)),
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
                                if (member.clubPosition.isNotEmpty)
                                  Text(
                                    '직책: ${member.clubPosition}',
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
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
