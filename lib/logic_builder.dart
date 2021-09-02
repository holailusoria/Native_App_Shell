import 'dart:io' as io show File;
import 'web_view_container.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StartPageStateless extends StatelessWidget {
  const StartPageStateless({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartPageStateful(),
    );
  }
}

class StartPageStateful extends StatefulWidget {
  const StartPageStateful({Key? key}) : super(key: key);

  @override
  _StartPageStatefulState createState() => _StartPageStatefulState();
}

class _StartPageStatefulState extends State<StartPageStateful> {
  String? appUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      String data = await readData();
      if (data.isNotEmpty)
        _handleUrlButtonPress(context, await readUrl(), data);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<io.File> _localFile() async {
    final path = await _localPath;
    print(path);
    return io.File('$path/savedApp.txt');
  }

  Future<String> readData() async {
    try {
      final file = await _localFile();

      if (!file.existsSync()) await file.create();

      String content = await file.readAsString();

      if (content.isNotEmpty)
        return content.substring(0, content.indexOf('~:'));

      print('Note: Empty content in file');
      return content;
    } catch (e) {
      throw new Exception(e);
    }
  }

  Future<String> readUrl() async {
    final file = await _localFile();

    String content = await file.readAsString();
    return content.substring(content.indexOf('~:') + 2, content.length);
  }

  Future writeData() async {
    final file = await _localFile();
    //Write the file
    return file.writeAsString('userApp~:$appUrl');
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
              Text('Set up the URL of your application in UI Builder'),
              Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: textFormFieldBuilder()),
              ElevatedButton(
                onPressed: () async => await writeData().then((value) async =>
                    _handleUrlButtonPress(
                        context, await readUrl(), await readData())),
                child: Text('Set'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleUrlButtonPress(BuildContext context, String url, String name) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url, name)));
  }

  TextFormField textFormFieldBuilder() {
    return TextFormField(
      onChanged: (text) => {
        appUrl = text,
        print(appUrl),
      },
      style: TextStyle(
        fontSize: 20.0,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          Icons.link,
          color: Colors.grey.shade700,
          size: 24.0,
        ),
        hintText: 'Your own URL',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
