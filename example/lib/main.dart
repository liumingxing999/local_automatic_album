import 'package:flutter/material.dart';
import 'package:local_automatic_album/local_automatic_album.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static var message = "未开始";

  void _incrementCounter(value) {
    setState(() {
      message = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    AutomaticAlbum aublm = new AutomaticAlbum();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$message',
              style: Theme.of(context).textTheme.headline5,
            ),
            Positioned(
                child: Center(
                  child:
                  new MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('开启自动备份'),
                    onPressed: () async {
                      var openMessage = await aublm.automaticAlbum(number: 5);
                      _incrementCounter(openMessage);
                    },
                  ),
                )
            ),
            Positioned(
                child: Center(
                  child:
                  new MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('关闭自动备份'),
                    onPressed: () async {
                      var closeMessage = await aublm.closeAutomaticAlbum();
                      _incrementCounter(closeMessage);
                    },
                  ),
                )
            ),
            Positioned(
                child: Center(
                  child:
                  new MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('点我获取数据'),
                    onPressed: () async {
                      _incrementCounter("请耐心等待约1分钟");
                      var allData = await aublm.getPhotoDataAll();
                      _incrementCounter("${allData.length}条数据");
                    },
                  ),
                )
            ),
            Positioned(
                child: Center(
                  child:
                  new MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('备份更新时间'),
                    onPressed: () async {
                      var updateTime = await aublm.getLastPhotoUpdateTime();
                      _incrementCounter(updateTime);
                    },
                  ),
                )
            ),
            Positioned(
                child: Center(
                  child:
                  new MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: new Text('清空重置'),
                    onPressed: () async {
                      var clearData = await aublm.clearCache();
                      _incrementCounter(clearData);
                    },
                  ),
                )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
