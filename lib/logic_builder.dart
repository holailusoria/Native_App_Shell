import 'web_view_container.dart';
import 'package:flutter/material.dart';

class StartPageStateless extends StatelessWidget {
  String appUrl = 'https://backendles.com'.toLowerCase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: appUrl.startsWith('http') && appUrl.contains('backendless')
          ? WebViewContainer(appUrl)
          : StartPageStateful(),
    );
  }
}

class StartPageStateful extends StatefulWidget {
  const StartPageStateful({Key? key}) : super(key: key);

  @override
  _StartPageStatefulState createState() => _StartPageStatefulState();
}

class _StartPageStatefulState extends State<StartPageStateful> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 120.0),
          child: Image.asset(
            'images/backendless_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Please enter the URL of your UI Builder application in \'appUrl\' variable',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
