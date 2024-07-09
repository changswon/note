import 'package:flutter/material.dart';
import 'package:note/screens/home/searchresultdetailscreen.dart';

class SearchResultScreen extends StatelessWidget {
  final Map<String, dynamic> searchResults;
  final String searchWord;

  const SearchResultScreen({
    Key? key,
    required this.searchResults,
    required this.searchWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 검색 결과에서 회원 목록을 추출합니다.
    List<dynamic> members = searchResults['member'] ?? [];

    // 검색어가 비어 있는 경우에는 전체 회원 목록을 표시합니다.
    if (searchWord.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('전체 회원 목록'),
        ),
        body: ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            final name = member['mber_name'];

            return ListTile(
              title: Text(name ?? 'No Name'),
              onTap: () {
                // 클릭했을 때 필요한 로직을 추가합니다.
              },
            );
          },
        ),
      );
    }

    // 검색어가 비어 있지 않은 경우에는 검색어와 일치하는 회원만 표시합니다.
    List<dynamic> matchedMembers = members.where((member) {
      final name = member['mber_name'];
      return name?.toLowerCase().contains(searchWord.toLowerCase()) ?? false;
    }).toList();

    // 검색 결과가 없는 경우에는 메시지를 표시합니다.
    if (matchedMembers.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('검색 결과'),
        ),
        body: Center(
          child: Text('등록된 회원이 아닙니다.'),
        ),
      );
    }

    // 검색 결과를 표시합니다.
    return Scaffold(
      appBar: AppBar(
        title: Text('검색 결과'),
      ),
      body: ListView.builder(
        itemCount: matchedMembers.length,
        itemBuilder: (context, index) {
          final member = matchedMembers[index];
          final name = member['mber_name'];

          return ListTile(
            title: Text(name ?? 'No Name'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResultDetailScreen(member: Member.fromJson(member))),
              );
            },
          );
        },
      ),
    );
  }
}
