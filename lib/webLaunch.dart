import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:news/themes.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebLaunch extends StatelessWidget {
  final String url;

  WebLaunch({this.url});
  @override
  Widget build(BuildContext context) {
    print(url);
    return /*WebviewScaffold(
      url: url,
      appBar: new AppBar(
        title: new Text("Widget webview"),
      ),
    );*/
    SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('WebPage',style: TextStyle(color: (isDark)?darkTextColor:lightTextColor),),
          iconTheme: (isDark)?IconThemeData(color: Colors.white):IconThemeData(color: Colors.black),
          backgroundColor: (isDark)?darkTheme.backgroundColor:lightTheme.backgroundColor,
          centerTitle: true,
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(icon: Icon(Icons.content_copy), tooltip: 'Copy Url',onPressed: () {
                Clipboard.setData(ClipboardData(text: url)).then((value){
                  final snackBar = SnackBar(
                    content: Text('Copied to Clipboard'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {},
                    ),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                });
              }),
            ),
            IconButton(icon: Icon(Icons.language), tooltip: 'Open in Browser',onPressed: () async {
              await _launchURL(url);
            }),
          ],
        ),
        body: FutureBuilder(
            future: http.get(url),
            initialData: "Loading text..",
            builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.done) {
                return WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                );
              } else
                return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
