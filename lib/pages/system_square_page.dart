import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid_flutter/http/api.dart';
import 'package:wanandroid_flutter/http/http.dart';
import 'package:wanandroid_flutter/models/article.dart';
import 'package:wanandroid_flutter/models/system_article.dart';
import 'package:wanandroid_flutter/pages/webview_page.dart';
import 'package:wanandroid_flutter/widgets/article_item.dart';

class SystemSquarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SystemSquarePageState();
  }
}

class SystemSquarePageState extends State<SystemSquarePage>
    with AutomaticKeepAliveClientMixin {
  int curPage = 0;
  List<Article> articleList = new List();
  EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new EasyRefreshController();
    loadSystemSquare(curPage);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      controller: _controller,
      header: ClassicalHeader(),
      footer: ClassicalFooter(),
      onRefresh: () async {
        loadSystemSquare(0);
      },
      onLoad: () async {
        loadSystemSquare(curPage);
      },
      child: ListView.separated(
        itemBuilder: (context, index) {
          return createSystemSquareItem(index);
        },
        separatorBuilder: (context, index) {
          return Divider(
            indent: 12,
            endIndent: 12,
            height: 0.5,
          );
        },
        itemCount: articleList.length,
      ),
    );
  }

  createSystemSquareItem(int index) {
    Article article = articleList[index];
    return ArticleItem(
      article.title,
      article.niceDate,
      article.author.isNotEmpty ? article.author : article.shareUser,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => WebViewPage(
              url: article.link,
            ),
          ),
        );
      },
    );
  }

  void loadSystemSquare(int page) async {
    var result = await HttpClient.getInstance()
        .get(Api.SQUARE_ARTICLE, data: {"page": page});
    print("page = $page, result = $result");
    curPage = page + 1;
    SystemArticle squareArticle = SystemArticle.fromJson(result);
    var articles = squareArticle.datas;
    setState(() {
      if (page == 0) {
        articleList.clear();
      }
      articleList.addAll(articles);
    });
  }

  void onItemClick(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => WebViewPage(
          url: articleList[index].link,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}