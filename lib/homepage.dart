import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news/newsDetailScreen.dart';
import 'package:news/newsUnits.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:news/themes.dart';

class HomePage extends StatefulWidget {
  String category = 'general';

  HomePage({
    this.category = 'general',
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsUnits newsUnits;
  List<Article> articleList = List();

  List<String> categoryList = [
    'general',
    'business',
    'health',
    'science',
    'sports',
    'technology',
    'entertainment'
  ];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  var width;

  Future _onRefresh() async {
    return await http
        .get(
            'https://newsapi.org/v2/top-headlines?country=in&apiKey=5009b812cc9449f191c3528e1f695c15')
        .then((value) => () {
              setState(() {});
            });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Scaffold(
          backgroundColor:
              (isDark) ? darkTheme.backgroundColor : lightTheme.backgroundColor,
          drawer: Drawer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Switch(
                  value: isDark,
                  onChanged: (value) {
                    setState(() {
                      isDark = value;
                    });
                  },
                ),
                Text('Dark Theme'),
              ],
            ),
          ),
          appBar: AppBar(
            iconTheme: (isDark)
                ? IconThemeData(color: Colors.white)
                : IconThemeData(color: Colors.black),
            backgroundColor: (isDark)
                ? darkTheme.backgroundColor
                : lightTheme.backgroundColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              '${(widget.category == 'general') ? 'NEWS' : (widget.category).toUpperCase()} FEED',
              style:
                  TextStyle(color: (isDark) ? darkTextColor : lightTextColor),
            ),
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _onRefresh,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: (isDark)
                            ? darkTheme.cardColor
                            : lightTheme.cardColor,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  category: categoryList[index],
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${categoryList[index]}',
                              style: TextStyle(
                                  color: (isDark)
                                      ? darkTextColor
                                      : lightTextColor),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: FutureBuilder(
                      future: http.get(
                          'https://newsapi.org/v2/top-headlines?country=in&category=${widget.category}&apiKey=5009b812cc9449f191c3528e1f695c15'),
                      initialData: "Loading text..",
                      builder:
                          (BuildContext context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.done) {
                          //_refreshIndicatorKey.currentState.deactivate();
                          newsUnits =
                              newsUnitsFromJson(asyncSnapshot.data.body);
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
              ],
            ),
          ),
        ),
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
        color: (isDark) ? darkTheme.cardColor : lightTheme.cardColor,
        child: Column(
          children: <Widget>[
            //CHECKING WHETHER THE IMAGE IS PRESENT OR NOT
            (articleList[index].urlToImage != null)
                ? ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                    child: FadeInImage.memoryNetwork(
                      placeholderCacheWidth: 300,
                      placeholderCacheHeight: 150,
                      fit: BoxFit.fill,
                      placeholder: kTransparentImage,
                      image: articleList[index].urlToImage,
                    ),
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
                  color: (isDark) ? darkTextColor : lightTextColor,
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
                      color: (isDark) ? darkTextColor : lightTextColor,
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
                      color: (isDark) ? darkTextColor : lightTextColor,
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
