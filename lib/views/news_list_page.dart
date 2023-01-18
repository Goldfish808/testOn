import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/dto_model/articles_model.dart';
import 'package:fluttertest/repository/articles_repository.dart';
import 'package:fluttertest/views/news_detail_page.dart';

import 'package:get/get.dart';

import '../controller/controller.dart';
import 'components/home_app_bar.dart';

class NewsListPage extends StatefulWidget {
  NewsListPage({Key? key}) : super(key: key);

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  final controller = Get.put(CountController());
  ArticlesRepository? articles;
  @override
  void initState() {
    super.initState();
    Dio dio = Dio();

    articles = ArticlesRepository(dio);

    Future.microtask(() async {
      //통신코드
      final resp = await articles?.getNews();

      List<ArticlesModel>? news = resp?.articles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(appBarTitle: "News", context: context),
      body: FutureBuilder(
        future: articles!.getNews(),
        initialData: [],
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print("ResponseDTO 확인하기 ${snapshot.data.articles.length}");
          final ids = snapshot.data.articles.length;

          return ListView.builder(
              itemCount: ids,
              itemBuilder: (_, index) {
                return FutureBuilder(
                  future: articles!.getNews(),
                  builder: (_, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    //print("snapshot 확인하기 ${snapshot.data.articles.length}");
                    return buildNewsList(articlesModel: snapshot.data.articles[index]);
                  },
                );
              });
        },
      ),
    );
  }

  Widget buildNewsList({required ArticlesModel articlesModel}) {
    print("이미지 확인해보기 ${articlesModel.urlToImage}");
    return InkWell(
      onTap: () {
        Get.to(() => NewsDetailPage(article: articlesModel));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 30, top: 20),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "기사 제목 ${articlesModel.title}",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "기사 내용 ${articlesModel.description}",
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(articlesModel.urlToImage.toString(), fit: BoxFit.fill)),
                      ),
                      _buildLikesButton(articlesModel: articlesModel)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Divider(thickness: 2.0),
          ],
        ),
      ),
    );
  }

  Widget _buildLikesButton({required ArticlesModel articlesModel}) {
    return Positioned(
      top: 120,
      left: 120,
      child: InkWell(
        child: Icon(
          (articlesModel.likes == null) || (articlesModel.likes == false)
              ? CupertinoIcons.heart
              : CupertinoIcons.heart_fill,
          color: Colors.lightBlue,
        ),
        onTap: () {},
      ),
    );
  }
}
