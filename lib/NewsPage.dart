import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotrak/WebViewContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cotrak/blocs/news_bloc/bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

const primaryColor = Color(0xff15406C);
const primaryColorLight1 = Color(0xff2F5A86);
const primaryColorLight2 = Color(0xff48739F);
const primaryColorLight3 = Color(0xff628DB9);
const primaryColorLight4 = Color(0xff7BA6D2);
const secondaryColor = Color(0xffE8F0FB);

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  NewsBloc _newsBloc;

  @override
  void initState() {
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _newsBloc.dispatch(FetchNews());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
          if (state is NewsLoaded)
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                  child: Text(
                    "Trending News",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: secondaryColor),
                  ),
                ),
                Expanded(child: NewsList(newsList: state.climateNewsList)),
              ],
            );
          if (state is NewsUninitialized)
            return Center(child: CircularProgressIndicator());
          return Container();
        }),
      ],
    );
  }
}

class NewsList extends StatelessWidget {
  const NewsList({
    Key key,
    @required this.newsList,
  }) : super(key: key);

  final List newsList;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 70),
      child: ListView.builder(
          itemCount: newsList.length,
          padding: EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => _handleURLButtonPress(
                  context, newsList[index]['url'], "Back To News List"),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100.0,
                ),
                child: Card(
                  elevation: 0,
                  child: CachedNetworkImage(
                    imageUrl: newsList[index]['urlToImage'] != null &&
                            newsList[index]['urlToImage'].isNotEmpty
                        ? newsList[index]['urlToImage']
                        : 'https://dummyimage.com/140x100/ffffff/ffffff.png',
                    imageBuilder: (context, imageProvider) => Container(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Image(
                              image: imageProvider,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              height: 200,
                            ),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(15),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          newsList[index]['title'] ?? '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          newsList[index]['description'] ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 15, bottom: 10),
                                  child: Text(
                                      DateFormat.yMMMd().format(DateTime.parse(
                                          newsList[index]['publishedAt'])),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor)),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 5, bottom: 10),
                                  child: Text(
                                    newsList[index]['source']['name'] ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    placeholder: (context, url) => SpinKitPulse(
                      color: Colors.blueGrey,
                      size: 25.0,
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.sentiment_very_dissatisfied,
                            size: 30,
                          ),
                          Text("Something went wrong.")
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, title)));
  }
}
