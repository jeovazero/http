import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const lines = """
E agora, José?
A festa acabou,
a luz apagou,
o povo sumiu,
a noite esfriou,
e agora, José?
e agora, você?
você que é sem nome,
que zomba dos outros,
você que faz versos,
que ama, protesta?
e agora, José?
""";

int countLines(String text) {
  final RegExp regExp = RegExp(r"\n\r?");
  final Iterable matches = regExp.allMatches(text);
  return matches.length + 1;
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController(
    text: lines,
  );

  final _focusNode = FocusNode();
  final _style = const TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.bold,
    fontFamily: "FiraCode",
    fontSize: 24,
  );

  final _numberStyle = const TextStyle(
    color: Colors.lightBlue,
    decoration: null,
    textBaseline: null,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    height: 1.225,
  );

  Widget text(int n) => Text(
        n.toString(),
        style: _numberStyle,
      );
  final _cursorColor = Colors.white;
  final _backgroundCursorColor = Colors.grey;
  late int count;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _controller.dispose();
    super.dispose();
  }

  void _showValue() {
    final text = _controller.text;
    debugPrint('Text field: $text (${text.characters.length})');
  }

  void _setCount() {
    final text = _controller.text;
    count = countLines(text);
    setState(() {}); // fight me
    debugPrint('Lines $count');
  }

  @override
  void initState() {
    super.initState();

    count = countLines(_controller.text);
    // Start listening to changes.
    _controller.addListener(_showValue);
    _controller.addListener(_setCount);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTextStyle(
      style: _style,
      child: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(count, text),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: 4,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 4),
                  ],
                ),
                Expanded(
                  child: EditableText(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: _style,
                    maxLines: null,
                    minLines: null,
                    expands: true,
                    cursorColor: _cursorColor,
                    backgroundCursorColor: _backgroundCursorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
