// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../config/constantClass.dart';


class WebviewScreen extends StatefulWidget {
  static const id = '/webview';
   String name;
  String url;
  WebviewScreen({this.name, this.url});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  WebViewPlusController _controller;
  String initurl;
  bool isProgress = true;
  // trx: "https://tronscan.org/#/transaction/",
  // eth: "https://etherscan.io/tx/",
  // bsc: "https://bscscan.com/tx/",
  @override
  void initState() {
setState(() {

  initurl=widget.name=="trx"?"https://tronscan.org/#/transaction/":widget.name=="eth"?"https://etherscan.io/tx/":"https://bscscan.com/tx/";

});    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  day==false? Colors.black:Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewPlus(
              serverPort: 5353,
              javascriptChannels: null,
              initialUrl: initurl+widget.url,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageFinished: (url) {
                _controller.getHeight().then((double height) {
                  setState(() {
                    isProgress = false;
                  });
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              onProgress: (value) {
                if (value == 100) {
                  setState(() {
                    isProgress = false;
                  });
                }
              },
            ),
            isProgress
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
