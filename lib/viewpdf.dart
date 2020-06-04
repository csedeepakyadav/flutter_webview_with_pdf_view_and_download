import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:webdownload/main.dart';

class ViewPDF extends StatefulWidget {
  final String pdfUrl;
  ViewPDF({this.pdfUrl});
  @override
  _ViewPDFState createState() => _ViewPDFState();
}

class _ViewPDFState extends State<ViewPDF> {
  PDFDocument doc;
  bool _isLoading;

   loadpdf() async {
    setState(() {
      _isLoading = true;
    });
    doc = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _isLoading = false;
    loadpdf();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WebDownload()),
                );
              },
              child: Icon(Icons.arrow_back_ios))),
      body: Center(
          child: _isLoading
              ?  Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text('Please Wait PDF is Loading ...')
                ],
              )
              : PDFViewer(document: doc)),
    );
  }
}
