import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  dynamic newsItem;

  DetailScreen({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: TextButton(
          child: Text(
            "뒤로가기",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이미지
              Container(
                /// 최대길이로 늘어나게함
                width: double.infinity,
                child: newsItem["urlToImage"] == null
                    ? ClipRRect(
                        child: Image.asset("assets/no-pictures.png"),
                        borderRadius: BorderRadius.circular(10),
                      )
                    : ClipRRect(
                        child: Image.network(
                          newsItem["urlToImage"],
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
              ),
              // 제목
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  newsItem["title"],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // 일시
              Align(
                child: Text(
                  formatDate(newsItem["publishedAt"]),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
              // 설명
              Text(newsItem["decription"] ?? "내용 없음"),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String strDate) {
    final dateTime = DateTime.parse(strDate);
    final formatter = DateFormat("yyyy.MM.dd HH:mm");
    return formatter.format(dateTime);
  }
}
