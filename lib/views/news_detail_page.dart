import 'package:flutter/material.dart';
import 'package:fluttertest/dto_model/articles_model.dart';
import 'package:fluttertest/views/components/home_app_bar.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatelessWidget {
  NewsDetailPage({Key? key, required this.article}) : super(key: key);

  final ArticlesModel article;
  @override
  Widget build(BuildContext context) {
    DateTime at = DateTime.parse(article.publishedAt.toString());

    print("시간 확인 해보자 ${DateFormat('yyyy.mm.dd').format(at)}");
    return Scaffold(
      appBar: HomeAppBar(context: context, appBarTitle: "Details"),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "${article.title}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${DateFormat('yyyy.mm.dd').format(at)}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text("${article.author}"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.urlToImage.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("${article.description}")
          ],
        ),
      ),
    );
  }
}