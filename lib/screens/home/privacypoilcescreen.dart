import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보처리방침'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '팔각회 스마트 회원수첩',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '이하 "회원수첩"은 고객님의 개인정보를 중요시하며, "정보통신망 이용촉진 및 정보보호"에 관한 법률을 준수하고 있습니다. 회사는 개인정보취급방침을 통하여 고객님께서 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있으며, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드립니다. 회사는 개인정보취급방침을 개정하는 경우 웹사이트 공지사항을 통하여 공지할 것입니다.',
            ),
            SizedBox(height: 16.0),
            Text(
              '1. 수집하는 개인정보 항목',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '회사는 견적문의 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.\n'
              '\n'
              '수집항목 : 이름, 이메일, 회사명, 부서, 전화번호, 소속, 직위, 시/도'

            ),
            SizedBox(height: 16.0),
            Text(
              '2. 개인정보의 수집 및 이용목적',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '회사는 수집한 개인정보를 회원목록 제공을 위해 활용합니다.\n'
              '-회원수첩 회원목록 제공'
            ),
            SizedBox(height: 16.0),
            Text(
              '3. 개인정보의 보유 및 이용기간',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
                '회사는 개인정보 수집 및 이용목적이 달성된 후에는 예외 없이 해당 정보를 지체 없이 파기합니다.'
            ),
            SizedBox(height: 16.0),
            Text(
              '4. 개인정보의 파기절차 및 방법',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
                '회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체없이 파기합니다. 파기절차 및 방법은 다음과 같습니다.\n'
                '-전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.\n'
                '-종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.'
            ),
            SizedBox(height: 16.0),
            Text(
              '5. 개인정보 제공',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
                '회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.\n'
                '이용자들이 사전에 동의한 경우 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우'
            ),
            SizedBox(height: 16.0),
            Text(
              '6. 수집한 개인정보의 위탁',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
                '회사는 고객님의 동의없이 고객님의 정보를 외부 업체에 위탁하지 않습니다.'
            ),
            SizedBox(height: 16.0),
            Text(
              '7. 이용자 및 법정대리인의 권리와 그 행사방법',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
                '이용자는 언제든지 등록되어 있는 자신의 개인정보를 조회하거나 수정할 수 있으며, 개인정보관리책임자에게 서면, 전화 또는 이메일로 연락하시면 지체없이 조치하겠습니다.\n'
                '귀하가 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체없이 통지하여 정정이 이루어지도록 하겠습니다.\n'
                '회사는 이용자의 요청에 의해 해지 또는 삭제된 개인정보는 "회사가 수집하는 개인정보의 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.\n'
                '만 14세 미만 아동의 경우, 법정대리인이 아동의 개인정보를 조회하거나 수정할 권리, 수집 및 이용 동의를 철회할 권리를 가집니다.'
            ),
            SizedBox(height: 16.0),
            Text(
              '8. 개인정보 자동수집 장치의 설치·운영 및 그 거부에 관한 사항',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
                '쿠키 등 인터넷 서비스 이용 시 자동 생성되는 개인정보를 수집하는 장치를 운영하지 않습니다.'
            ),
            SizedBox(height: 16.0),
            Text(
              '9. 개인정보에 관한 민원서비스',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
                '회사는 고객의 개인정보를 보호하고 개인정보와 관련한 불만을 처리하기 위하여 아래와 같이 관련 부서 및 개인정보관리책임자를 지정하고 있습니다.\n'
                '\n'
                '-개인정보담당부서 : 가나엔터프라이즈\n'
                '-전화번호 : 052-900-7811\n'
                '-이 메 일 : design@gana21.com\n'
                '\n'
            '귀하께서는 회사의 서비스를 이용하시며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자 혹은 담당부서로 신고하실 수 있습니다. 회사는 이용자들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다.\n'
            '기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.\n'
                '\n'
            '1. 개인정보침해신고센터 (http://privacy.kisa.or.kr/118)\n'
            '2. 대검찰청 사이버범죄수사단 ( cybercid@spo.go.kr/02-3480-3571)\n'
            '3. 경찰청 사이버테러대응센터(http://cyberbureau.police.go.kr /182)'
            ),
          ],
        ),
      ),
    );
  }
}
