import 'package:fl_web_view/PageNotFound.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(
      home: const PocketPillsWV(),
      theme: ThemeData(primarySwatch: Colors.deepPurple),
    ));

class PocketPillsWV extends StatefulWidget {
  const PocketPillsWV({super.key});

  @override
  PocketPillsWVState createState() => PocketPillsWVState();
}

class PocketPillsWVState extends State<PocketPillsWV> {
  late final WebViewController _controller;
  double progressValue = 0;
  bool isLoading = true;
  bool isError = false;

  _launchURL(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $Uri';
    }
  }

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onProgress: (int progress) {
          setState(() {
            progressValue = progress / 100;
          });
        }, onPageStarted: (String url) {
          setState(() {
            isLoading = true;
          });
        }, onPageFinished: (String url) {
          setState(() {
            isLoading = false;
          });
        }, onWebResourceError: (WebResourceError error) {
          setState(() {
            isError = true;
          });
        }, onNavigationRequest: (NavigationRequest request) async {
          if (request.url.contains("mailto:") || request.url.contains("tel:")) {
            final splitUrl = request.url.split(':');
            final uri = Uri(
              scheme: splitUrl[0],
              path: '+${splitUrl[1]}',
            );
            _launchURL(uri);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }),
      )
      ..enableZoom(false) // DISABLE ZOOM TO PREVENT AUTO-ZOOM ON INPUT FOCUS
      ..loadRequest(Uri.parse('https://testapp.pocketpills.com/?debug=true'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: isError
          ? const PageNotFound()
          : isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: LinearProgressIndicator(
                        value: progressValue,
                      ),
                    ),
                  ],
                )
              : SafeArea(
                  child: WebViewWidget(
                    controller: _controller,
                  ),
                ),
    );
  }
}
