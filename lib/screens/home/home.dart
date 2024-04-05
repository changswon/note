import 'package:flutter/material.dart';
import 'package:note/constants.dart';
import 'package:note/screens/memberlist/memberlist.dart';
import 'package:note/screens/jigoo/jigoo.dart';
import 'package:note/screens/palgaklist/palgaklist.dart';
import 'package:note/screens/home/searchresultscreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BodyScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '전체 연락처',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '개인정보처리방침',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MemberListScreen()),
            );
          }
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.blue,
      toolbarHeight: 60.0,
      title: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Image.asset(
                  'images/18_logo.png',
                  height: 60.0,
                  width: 270.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final TextEditingController _searchController = TextEditingController();

class BodyScreen extends StatelessWidget {
  const BodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'images/mnote.jpg',
            height: 200.0,
            width: 410.0,
          ),
          Column(
            children: [
              TextField(
                controller: _searchController, // _searchController 설정
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                  hintText: '회원명 검색',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(
                      color: kPrimaryColor,
                      width: 3,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      // _searchController를 사용하여 검색어 획득
                      String searchWord = _searchController.text.trim();
                      print('검색: $searchWord');
                      print('검색어 (공백 제거 전): ${_searchController.text}');
                      // 검색어가 비어있지 않다면 searchMember 함수 호출
                      if (searchWord.isNotEmpty) {
                        searchMember(context, searchWord);
                      }
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JigooScreen()),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '지구임원단',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContentListScreen()),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '팔각회 목록',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
              Image.asset(
                'images/gana.jpg',
                height: 130.0,
                width: 410.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// 검색을 수행하는 함수
Future<void> searchMember(BuildContext context,String searchWord) async {
  var endpoint = 'http://ntpalgak.gananet.co.kr/api/member.php';
  var queryParameters = {
    'search_type': 'mber_name',
    'search_word': searchWord,
  };

  var uri = Uri.parse(endpoint).replace(queryParameters: queryParameters);

  try {
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print('Search API Response: $jsonData'); // API 응답 로그 출력
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchResultScreen(searchResults: jsonData, searchWord:searchWord,)),
      );

    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}