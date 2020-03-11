import 'package:http/http.dart' as http;
import 'package:news/newsUnits.dart';

NewsUnits newsUnits;

Future getData(response) async{
  /*var url = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=5009b812cc9449f191c3528e1f695c15';

  final response = await http.get(url);
*/
  newsUnits = newsUnitsFromJson(response.body);
  print('${response.body}');
  print('${newsUnits.articles[0].title}');
  return newsUnits;
}