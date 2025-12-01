import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QuizView extends StatefulWidget {

   final String Url;
     QuizView({required this.Url});
  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late WebViewController _controller;
  var loading = 0;
  


  @override
  void initState() {
    super.initState();
    // Initialize the WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)  // Enable JavaScript
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loading = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loading = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loading = 100;
          });
        },
      ))
      ..loadRequest(Uri.parse(widget.Url));
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            loading < 100
                ? LinearProgressIndicator(
                    color: Colors.purple,
                    value: loading / 100,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
