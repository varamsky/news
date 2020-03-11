import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news/loginPage.dart';
import 'package:news/newsDetailScreen.dart';
import 'package:news/newsUnits.dart';
//import 'package:news/loadData.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  bool isLogin;

  HomePage({
    this.isLogin = false,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsUnits newsUnits;
  List<Article> articleList = List();

  var width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: ListTile(
              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage())),
              title: Text((widget.isLogin)?'Logout':'Login',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.normal,color: Colors.white),),
            ),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text('NEWS FEED'),
        ),
        body: FutureBuilder(
            future: http.get(
                'https://newsapi.org/v2/top-headlines?country=in&apiKey=5009b812cc9449f191c3528e1f695c15'),
            initialData: "Loading text..",
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.done) {
                newsUnits = newsUnitsFromJson(asyncSnapshot.data.body);
                for (int i = 0; i < newsUnits.articles.length; ++i)
                  articleList.add(newsUnits.articles[i]);
                return ListView.builder(
                  itemCount: newsUnits.articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildCard(index),
                    );
                  },
                );
              } else
                return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget buildCard(int index) {
    int sec =
        DateTime.now().difference(articleList[index].publishedAt).inSeconds;
    int min =
        DateTime.now().difference(articleList[index].publishedAt).inMinutes;
    int hours =
        DateTime.now().difference(articleList[index].publishedAt).inHours;
    String agoText;
    int ago;
    if (hours != 0) {
      ago = hours;
      agoText = (ago == 1) ? '1 hour ago' : ago.toString() + ' hours ago';
    } else if (min != 0) {
      ago = min;
      agoText = (ago == 1) ? '1 minute ago' : ago.toString() + ' minutes ago';
    } else {
      ago = sec;
      agoText = ago.toString() + ' sec ago';
    }

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewsDetailScreen(
              article: articleList[index], agoText: agoText, index: index))),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Theme.of(context).cardColor,
        child: Column(
          children: <Widget>[
            //CHECKING WHETHER THE IMAGE IS PRESENT OR NOT
            (articleList[index].urlToImage != null)
                ? FadeInImage.memoryNetwork(
                    placeholderCacheWidth: 300,
                    placeholderCacheHeight: 150,
                    fit: BoxFit.fill,
                    placeholder: kTransparentImage,
                    image: articleList[index].urlToImage,
                  )
                : Container(
                    width: width,
                    height: 150.0,
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                articleList[index].title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    articleList[index].source.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                  child: Container(
                    height: 3.0,
                    width: 3.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 8.0),
                  child: Text(
                    agoText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
