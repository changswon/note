import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:note/screens/palgaklist/detailscreen.dart';

// API로부터 데이터 가져오기
Future<List<Content>> fetchContents() async {
  final response = await http.get(Uri.parse('http://ntpalgak.gananet.co.kr/api/content.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    List<Content> contents = [];

    for (int i = 0; i < data.length; i++) {
      contents.add(Content.fromJson(data[i] as Map<String, dynamic>));
    }

    return contents;
  } else {
    throw Exception('Failed to load contents');
  }
}

class Content {
  final String coId;
  final String coSubject;

  Content({
    required this.coId,
    required this.coSubject,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      coId: json['co_id'] as String,
      coSubject: json['co_subject'] as String,
    );
  }
}

class ContentListScreen extends StatefulWidget {
  @override
  _ContentListScreenState createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  Future<List<Content>>? _contents; // Future<List<Content>>? 타입으로 변경
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchContents();
  }

  Future<void> _fetchContents() async {
    setState(() {
      _isRefreshing = true; // 새로고침 상태로 설정
    });

    try {
      final contents = await fetchContents();
      setState(() {
        _contents = Future.value(contents); // Future<List<Content>>로 _contents 초기화
      });
    } catch (e) {
      // 에러 처리
      print('Error: $e');
    } finally {
      setState(() {
        _isRefreshing = false; // 새로고침 상태 해제
      });
    }
  }

  void _navigateToDetailScreen(BuildContext context, String coId, String coSubject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(coId: coId, coSubject: coSubject),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팔각회 목록'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchContents(),
        child: FutureBuilder<List<Content>>(
          future: _contents,
          builder: (context, snapshot) {
            if (_isRefreshing) {
              return Center(
                child: CircularProgressIndicator(), // 새로고침 중이면 로딩 아이콘 표시
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(), // 데이터를 기다리는 동안 로딩 아이콘 표시
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Content content = snapshot.data![index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          content.coSubject,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: () {
                        _navigateToDetailScreen(context, content.coId, content.coSubject);
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            // 아직 데이터가 없는 경우에 대한 처리
            return Center(
              child: Text("No data available"), // 데이터 없음을 나타내는 텍스트 표시
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ContentListScreen(),
  ));
}
