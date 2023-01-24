import 'package:flutter/material.dart';
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
  // final Set<String> _favorites = <String>{};
  final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://testapp.pocketpills.com/?debug=true'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
      // floatingActionButton: _bookmarkButton(),
    );
  }
}
