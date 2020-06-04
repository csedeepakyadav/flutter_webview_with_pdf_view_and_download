import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webdownload/viewpdf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: ViewPDF(),
      debugShowCheckedModeBanner: false,
      home: WebDownload(),
    );
  }
}

class WebDownload extends StatefulWidget {
  @override
  _WebDownloadState createState() => _WebDownloadState();
}

class _WebDownloadState extends State<WebDownload> {
  Dio dio = new Dio();

// for future use
  /*  download() async {
    try {
      var response = await dio.download(
       "url", "file_name_with_extension",
        onReceiveProgress: (int sent, int total) {
          print("$sent $total");
        },
      );
      if (response.statusCode == 200) {
        print('yes');
      } else {
        print('no');
      }
    } catch (e) {
      print(e);
    }
  } */

  String pdfUrl = "";
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool isPDF;
  Future onurlchange() async {
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print(url);
      if (url.contains('.pdf')) {
        showDialog(
          context: context,
          builder: (_) => MainDialog(
            url: url,
          ),
        );
        flutterWebviewPlugin.hide();
        print('url containes');
        setState(() {
          isPDF = true;
        });
      } else {
        setState(() {
          isPDF = false;
        });
      }
      pdfUrl = url;
    });
  }

  _launchURL() async {
    // to launch on chrome

    String url = pdfUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    isPDF = false;
    onurlchange();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
          appBar: AppBar(
            actions: <Widget>[
              SizedBox(
                width: 10,
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: isPDF == true
                        ? Row(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewPDF(
                                                pdfUrl: pdfUrl,
                                              )),
                                    );
                                  },
                                  child: Icon(Icons.book)),
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                  onTap: () {
                                    _launchURL();
                                  },
                                  child: Icon(Icons.open_in_browser)),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          )
                        : null,
                  )
                ],
              )
            ],
          ),
          url:
              'https://file-examples.com/index.php/sample-documents-download/sample-pdf-download/',
          withZoom: true,
          withJavascript: true,
          withLocalStorage: true,
          hidden: true,
          allowFileURLs: true,
          initialChild: Container(
            // color: Colors.redAccent,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }
}

class MainDialog extends StatefulWidget {
  final String url;
  MainDialog({this.url});
  @override
  State<StatefulWidget> createState() => MainDialogState();
}

class MainDialogState extends State<MainDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(15.0),
              height: 180.0,
              decoration: ShapeDecoration(
                  color: Color.fromRGBO(41, 167, 77, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0),
                    child: Text(
                      "Are you sure, you want to logout?",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  )),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ButtonTheme(
                            height: 35.0,
                            minWidth: 110.0,
                            child: RaisedButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              splashColor: Colors.white.withAlpha(40),
                              child: Text(
                                'Logout',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0),
                              ),
                              onPressed: () {
                                /* setState(() {
                                  Route route = MaterialPageRoute(
                                      builder: (context) => LoginScreen());
                                  Navigator.pushReplacement(context, route);
                                }); */
                              },
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: ButtonTheme(
                              height: 35.0,
                              minWidth: 110.0,
                              child: RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                splashColor: Colors.white.withAlpha(40),
                                child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              ))),
                    ],
                  ))
                ],
              )),
        ),
      ),
    );
  }
}
