import 'package:flutter/material.dart';

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
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
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

class HLRange {
  // final int line; // no lines for now
  final int start;
  final int end;
  final TextStyle style;
  HLRange({
    // required this.line,
    required this.start,
    required this.end,
    required this.style,
  });
}

class MyTextEditingController extends TextEditingController {
  final List<HLRange> highlight;
  MyTextEditingController({required String text, required this.highlight})
      : super(text: text);

  @override
  TextSpan buildTextSpan({
    required context,
    TextStyle? style,
    required withComposing,
  }) {
    if (highlight.isEmpty) {
      return TextSpan(style: style, text: text);
    }

    List<InlineSpan> children = [];
    var index = 0;
    final len = text.length;
    for (final element in highlight) {
      debugPrint("${element.start}:${element.end}");
      if (index >= len) break;
      if (element.start <= index) {
        children.add(TextSpan(
          text: text.substring(index, element.end + 1),
          style: element.style,
        ));
        index = element.end + 1;
      } else {
        children.add(TextSpan(
          text: text.substring(index, element.start),
          style: style,
        ));
        if (element.start < len) {
          children.add(TextSpan(
            text: text.substring(element.start, element.end + 1),
            style: element.style,
          ));
          index = element.end + 1;
        } else {
          index = element.start;
        }
      }
    }
    debugPrint("index $index len $len");
    if (index < len) {
      children.add(TextSpan(
        text: text.substring(index, len),
        style: style,
      ));
    }
    return TextSpan(style: style, children: children);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = MyTextEditingController(
    text: lines,
    highlight: [
      HLRange(start: 0, end: 1, style: const TextStyle(color: Colors.amber)),
      HLRange(start: 2, end: 6, style: const TextStyle(color: Colors.green)),
      HLRange(start: 8, end: 12, style: const TextStyle(color: Colors.blue)),
      HLRange(start: 13, end: 13, style: const TextStyle(color: Colors.cyan)),
      HLRange(start: 14, end: 16, style: const TextStyle(color: Colors.yellow)),
      HLRange(start: 33, end: 35, style: const TextStyle(color: Colors.yellow)),
      HLRange(start: 37, end: 42, style: const TextStyle(color: Colors.grey)),
    ],
  );

  final _focusNode = FocusNode();
  final _style = const TextStyle(
    color: Colors.white,
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
  final _cursorColor = Colors.black;
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
    return DefaultTextStyle(
      style: _style,
      child: Container(
        color: Colors.black87,
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
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 4,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 4),
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
