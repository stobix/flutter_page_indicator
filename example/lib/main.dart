import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';

import 'package:flutter_page_indicator/flutter_page_indicator.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class RadioGroup extends StatefulWidget {
  final List<String> titles;

  final ValueChanged<int?> onIndexChanged;

  const RadioGroup({super.key, required this.titles, required this.onIndexChanged});

  @override
  State<StatefulWidget> createState() {
    return new _RadioGroupState();
  }
}

class _RadioGroupState extends State<RadioGroup> {
  int? _index = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < widget.titles.length; ++i) {
      list.add(((String title, int index) {
        return new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Radio<int>(
                value: index,
                groupValue: _index,
                onChanged: (int? index) {
                  setState(() {
                    _index = index;
                    widget.onIndexChanged(_index);
                  });
                }),
            new Text(title)
          ],
        );
      })(widget.titles[i], i));
    }

    return new Wrap(
      children: list,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 1;

  double size = 20.0;
  double activeSize = 30.0;

  late PageController controller;

  PageIndicatorLayout layout = PageIndicatorLayout.SLIDE;

  List<PageIndicatorLayout> layouts = PageIndicatorLayout.values;

  bool loop = false;

  @override
  void initState() {
    controller = new PageController();
    super.initState();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Container(
        color: Colors.red,
      ),
      Container(
        color: Colors.green,
      ),
      Container(
        color: Colors.blueAccent,
      ),
      Container(
        color: Colors.grey,
      )
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                    value: loop,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          controller = TransformerPageController(itemCount: 4, loop: true);
                        } else {
                          controller = new PageController(
                            initialPage: 0,
                          );
                        }
                        loop = value == true;
                      });
                    }),
                Text("loop"),
              ],
            ),
            RadioGroup(
              titles: layouts.map((s) {
                var str = s.toString();
                return str.substring(str.indexOf(".") + 1);
              }).toList(),
              onIndexChanged: (int? index) {
                if(index != null)
                setState(() {
                  _index = index;
                  layout = layouts[index];
                });
              },
            ),
            Expanded(
                child: Stack(
              children: <Widget>[
                loop
                    ? TransformerPageView.children(
                        children: children,
                        pageController: controller as TransformerPageController,
                      )
                    : PageView(
                        controller: controller,
                        children: children,
                      ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: PageIndicator(
                      layout: layout,
                      size: size,
                      activeSize: activeSize,
                      controller: controller,
                      space: 5.0,
                      count: 4,
                    ),
                  ),
                )
              ],
            ))
          ],
        ));
  }
}
