import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class VerticalAd extends StatefulWidget {
  const VerticalAd({super.key});

  @override
  State<VerticalAd> createState() => _VerticalAdState();
}

class _VerticalAdState extends State<VerticalAd> {
  final WebviewController controller = WebviewController();
  final String adSenseCode = '''
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Anuncio</title>
    </head>
    <body>
      <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-4319718180321524"
          crossorigin="anonymous"></script>
      <ins class="adsbygoogle"
          style="display:block"
          data-ad-client="ca-pub-4319718180321524"
          data-ad-slot="4170488686"
          data-ad-format="auto"
          data-full-width-responsive="true"></ins>
      <script>
          (adsbygoogle = window.adsbygoogle || []).push({});
      </script>
    </body>
    </html>
  ''';

  // final controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.disabled)
  //   // ..loadHtmlString(adSenseCode);
  //   ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  void initState() {
    // ..setJavaScriptMode(JavaScriptMode.disabled)
    // ..loadHtmlString(adSenseCode);
    controller.initialize().whenComplete(() {
      // controller.loadStringContent(adSenseCode);
      controller.loadUrl("https://breakmoonla.com");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      color: Colors.red,
      child: Webview(controller),
    );
  }
}
