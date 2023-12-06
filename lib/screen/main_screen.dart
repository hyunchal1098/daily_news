import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> listNewsInfo = [];

  //하단 배너 아이디
  late String admobBannerId;
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    getNewsInfo();

    //애드몹 세팅
    setAdmob();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff424242),
        leading: Icon(
          Icons.newspaper,
          color: Colors.black,
        ),
        title: Text(
          "HeadLine News",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: listNewsInfo.length,
            itemBuilder: (context, index) {
              var newsItem = listNewsInfo[index];
              return GestureDetector(
                child: Container(
                  /// Container 영역 안에서 차곡차곡 쌓는다는 의미임
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      //이미지
                      Container(
                        margin: EdgeInsets.all(16),
                        height: 170,

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
                      //반투명 검정 UI
                      Container(
                        width: double.infinity,
                        height: 57,
                        decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                            color: Colors.black.withOpacity(0.7)),
                        child: Container(
                          margin: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                newsItem["title"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Align(
                                child: Text(
                                  formatDate(newsItem["publishedAt"]),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.bottomRight,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //하얀색 뉴스제목, 일자 테스트
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/detail", arguments: newsItem);
                },
              );
            },
          ),),

          SizedBox(
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            child: AdWidget(
              ad: _bannerAd,
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String strDate) {
    final dateTime = DateTime.parse(strDate);
    final formatter = DateFormat("yyyy.MM.dd HH:mm");
    return formatter.format(dateTime);
  }

  // 뉴스 API 요청
  Future getNewsInfo() async {
    const apiKey = "049ac77d00c447b191131b1602e8bd26";
    const apiUrl =
        "https://newsapi.org/v2/top-headlines?country=kr&apiKey=$apiKey";

    try {
      //네트워크 통신은 비동기
      final response = await http.get(Uri.parse(apiUrl));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> reponseData = json.decode(response.body);
        setState(() {
          listNewsInfo = reponseData["articles"];
        });
        listNewsInfo.forEach((element) {
          print(element);
        });
      } else {
        throw Exception("Fail to load news");
      }
    } catch (error) {
      print(error);
    }
  }

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      //android
      if (kReleaseMode) {
        return "ca-app-pub-7777386281932313/4053045636"; // release unit ID
      } else {
        return "ca-app-pub-3940256099942544/6300978111"; // debug test ID
      }
    } else if (Platform.isIOS) {
      //ios
      if (kReleaseMode) {
        return "ca-app-pub-7777386281932313/8367695165 "; // release unit ID
      } else {
        return "ca-app-pub-3940256099942544/2934735716"; // debug test ID
      }
    } else {
      throw UnsupportedError("Unsupported Platform...");
    }
  }

  void setAdmob() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            // 광고 로드가 완료
          });
        },
        onAdFailedToLoad: (ad, error) {
          print(error.message);
        },
      ),
      request: AdRequest(),
    );
    _bannerAd.load();
  }
}
