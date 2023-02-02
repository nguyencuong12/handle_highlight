import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:highlight_text/highlight_text.dart';
// import 'package:richtext/class/highlightObject.dart';
// import 'package:richtext/highlight.dart';

import 'package:highlight_text/highlight_text.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:richtext/class/highlightObject.dart';
import 'package:richtext/controller/highlightController.dart';
import 'package:richtext/highlightCustom.dart';
import 'package:richtext/widget/mySelectTextCustom.dart';

// import 'package:simple_rich_text/simple_rich_text.dart';
// import 'package:zefyrka/zefyrka.dart';

class HighlightObject {
  String highlight;
  int start;
  int end;
  TextStyle? style;
  HighlightObject(
      {required this.highlight,
      required this.start,
      required this.end,
      this.style});
  @override
  String toString() {
    // TODO: implement toString
    return "Highlight: $highlight , Start : $start , End :$end";
  }
}

class RichTextEditingController extends TextEditingController {
  RichTextEditingController();
  String textInput = 'test';
  List<HighlightObject> wordsToMatchList = [];
  late TextRange rangeSelect;

  excuteHighlight(List<HighlightObject> result, TextRange range) {
    wordsToMatchList = result;
    rangeSelect = range;
    // wordsToMatchList = [
    //   // HighlightObject(highlight: "CUONG", start: 12, end: 24),
    //   // HighlightObject(highlight: "PHY", start: 26, end: 33),
    //   // HighlightObject(highlight: "CUONG", start: 35, end: 42),
    // ];

    notifyListeners();
    // return;
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners

    super.notifyListeners();
  }

  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    final List<InlineSpan> textSpanChildren = [];
    List<HighlightObject> _handleSpans = [];

    List<String> splitText = text.split(' ');

    if (wordsToMatchList.isEmpty) {
      textSpanChildren
          .add(TextSpan(style: TextStyle(color: Colors.black), text: text));
    } else {
      try {
        wordsToMatchList.sort((a, b) => a.start.compareTo(b.start));
        List<HighlightObject> tempRemove = [];
        //DON'T HANDLE HIGHLIGHTS IN THIS !!!
        // for (var i = 0; i < wordsToMatchList.length; i++) {
        //   if (i + 1 < wordsToMatchList.length) {
        //     if (wordsToMatchList[i + 1].start < wordsToMatchList[i].end) {
        //       print("REDUCE LEFT");
        //       int start = wordsToMatchList[i + 1].start;
        //       int end = wordsToMatchList[i].end;
        //       print("START $start");
        //       print("END $end");

        //       // tempRemove.add(wordsToMatchList[i + 1]);
        //       int lengthReduce =
        //           wordsToMatchList[i].end - wordsToMatchList[i + 1].start;
        //       print("REDUCE $lengthReduce");
        //       wordsToMatchList[i].end = wordsToMatchList[i].end - lengthReduce;
        //     }
        //   }
        // }

        // tempRemove.forEach((element) {
        //   wordsToMatchList.remove(element);
        // });
        // print("WORD AFTER REDUCE $wordsToMatchList");

        // wordsToMatchList.sort((a, b) => a.start.compareTo(b.end));

        ///BEGIN NORMAL TEXT
        _handleSpans.add(HighlightObject(
            style: TextStyle(color: Colors.black),
            highlight: text.substring(0, wordsToMatchList[0].start),
            start: 0,
            end: wordsToMatchList[0].start));

        //  HIGHLIGHT TEXT
        wordsToMatchList.forEach((element) => {
              _handleSpans.add(HighlightObject(
                  style: element.style,
                  highlight: text.substring(element.start, element.end),
                  start: element.start,
                  end: element.end))
            });
        _handleSpans.sort((a, b) => a.start.compareTo(b.start));
        for (var i = 0; i < wordsToMatchList.length; i++) {
          if (i + 1 < wordsToMatchList.length) {
            _handleSpans.add(HighlightObject(
                style: TextStyle(color: Colors.black),
                highlight: text.substring(
                    wordsToMatchList[i].end, wordsToMatchList[i + 1].start),
                start: wordsToMatchList[i].end,
                end: wordsToMatchList[i + 1].start));
          }
        }

        _handleSpans.sort((a, b) => a.start.compareTo(b.start));

        _handleSpans.add(HighlightObject(
            style: TextStyle(color: Colors.black),
            highlight: text.substring(_handleSpans.last.end, null),
            start: _handleSpans.last.end,
            end: text.length));
        _handleSpans.sort((a, b) => a.start.compareTo(b.start));

        // _handleSpans.forEach((element) {
        //   if(element.start <= wordsToMatchList)
        // });

        /////// !!! IMPORTANT RENDER !!!!!
        _handleSpans.forEach((element) {
          textSpanChildren
              .add(TextSpan(style: element.style, text: element.highlight));
        });
      } catch (err) {
        print("CATCH CALL");
        textSpanChildren.add(TextSpan(style: style, text: text));
      }
    }

    return TextSpan(
      children: textSpanChildren,
    );
  }

  void _addTextSpan(
    List<InlineSpan> textSpanChildren,
    String? textToBeStyled,
    TextStyle? style,
    GestureRecognizer? gestureRecognizer,
  ) {
    textSpanChildren.add(
      TextSpan(
        text: textToBeStyled,
        style: style,
        recognizer: gestureRecognizer,
      ),
    );
  }
  // TextSpan buildTextSpan({
  //   required BuildContext context,
  //   TextStyle? style,
  //   required bool withComposing,
  // }) {
  //   print("VALUE ${value.composing}");
  //   return TextSpan(
  //     style: style,
  //     children: <TextSpan>[
  //       if (value.composing.start != -1) ...[
  //         TextSpan(text: value.composing.textBefore(value.text)),
  //         TextSpan(
  //           style: const TextStyle(
  //             color: Colors.red,
  //             decoration: TextDecoration.underline,
  //           ),
  //           text: value.composing.textInside(value.text),
  //         ),
  //         TextSpan(text: value.composing.textBefore(value.text)),
  //       ]
  //     ],
  //   );
  // }

}

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RichTextEditingController _controller = RichTextEditingController();

  List<HighlightObject> _highlights = [];
  Color _pickerColor = Color(Colors.black.value);
  @override
  void initState() {
    _controller.text =
        "NGUYEN NGOC CUONG  test CUONG  zz1 PHY sqjhqf sf;1fjs  111";

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: _controller),
              TextButton(
                  onPressed: () => {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return Material(
                                  child: AlertDialog(
                                      actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("OK"))
                                  ],
                                      content: ColorPicker(
                                          pickerColor: _pickerColor,
                                          onColorChanged: (value) {
                                            setState(() {
                                              _pickerColor = value;
                                              print("VALUE $value");
                                            });
                                          })));
                            })
                      },
                  child: Text("Pick Color")),
              TextButton(
                  onPressed: () {
                    int start = _controller.selection.start;
                    int end = _controller.selection.end;
                    List<HighlightObject> _tempDelete = [];
                    List<HighlightObject> _tempAdd = [];

                    //HANDLE FOR TEXT
                    // for (var i = 0; i < _highlights.length; i++) {
                    //   if (start == _highlights[i].start ||
                    //       end == _highlights[i].end) {
                    //     _tempDelete.add(_highlights[i]);
                    //   }
                    //   // if (start <= _highlights[i].start &&
                    //   //     end >= _highlights[i].end) {
                    //   //   _tempDelete.add(_highlights[i]);
                    //   // }
                    //   // if (start >= _highlights[i].start &&
                    //   //     end <= _highlights[i].end) {
                    //   //   _tempDelete.add(_highlights[i]);
                    //   // }
                    // }

                    // _tempDelete.forEach((element) {
                    //   _highlights.remove(element);
                    // });

                    // _highlights.forEach((element) {
                    //   if (start >= element.start && end <= element.end) {
                    //     //Scale small size
                    //     String textBefore =
                    //         _controller.text.substring(element.start, start);
                    //     String textAfter =
                    //         _controller.text.substring(end, element.end);

                    //     if (textBefore.isNotEmpty) {
                    //       _tempAdd.add(HighlightObject(
                    //           style: element.style,
                    //           highlight: textBefore,
                    //           start: element.start,
                    //           end: start));
                    //     }
                    //     if (textAfter.isNotEmpty) {
                    //       _tempAdd.add(HighlightObject(
                    //           style: element.style,
                    //           highlight: textAfter,
                    //           start: end,
                    //           end: element.end));
                    //     }
                    //     _tempDelete.add(element);
                    //   } else {

                    //   }
                    // });

                    // _tempDelete.forEach((element) {
                    //   _highlights.remove(element);
                    // });
                    // _tempAdd.forEach((element) {
                    //   _highlights.add(element);
                    // });

                    if (_highlights.isEmpty) {
                      //FIRST HIGHLIGHT OBJECT
                      _highlights.add(HighlightObject(
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: _pickerColor),
                          start: start,
                          end: end,
                          highlight: _controller.text.substring(start, end)));
                    } else {
                      _highlights.add(HighlightObject(
                          style: TextStyle(
                              color: Colors.black,
                              backgroundColor: _pickerColor),
                          start: start,
                          end: end,
                          highlight: _controller.text.substring(start, end)));

                      for (var highlight in _highlights) {
                        if (highlight.start < start) {
                          print("HIHG $highlight");
                        }
                      }

                      // _highlights.forEach((element) {
                      //   print("ELEMENT $element");
                      //   if (element.start < start) {
                      //     _tempDelete.add(element);
                      //   }
                      // });

                      // else {
                      //   // _tempDelete.add(element);
                      //   print("EXIST $element");
                      //   if (start != element.start || end != element.end) {
                      //     print("EXIST 2 $element");
                      //   }

                    }
                    _tempDelete.forEach((element) {
                      _highlights.remove(element);
                    });
                    _highlights.sort((a, b) => a.start.compareTo(b.start));

                    print("HIGHLIGHT $_highlights");

                    // for (var i = 0; i < _highlights.length; i++) {
                    //   if (i + 1 < _highlights.length) {
                    //     if (_highlights[i + 1].start < _highlights[i].end) {
                    //       if (_highlights[i + 1].start > _highlights[i].start) {
                    //         //HANDLE LEFT HAND
                    //         print("LEFT HAND");
                    //         int lengthReduce =
                    //             _highlights[i].end - _highlights[i + 1].start;
                    //         _highlights[i].end =
                    //             _highlights[i].end - lengthReduce;
                    //         _highlights[i].highlight = _controller.text
                    //             .substring(
                    //                 _highlights[i].start, _highlights[i].end);
                    //       } else {
                    //         //HANDLE RIGHT HAND
                    //         _highlights
                    //             .sort((a, b) => a.start.compareTo(b.start));
                    //         print("RIGHT $_highlights");
                    //         if (_highlights[i].end > _highlights[i + 1].start) {
                    //           if (_highlights[i].start <
                    //                   _highlights[i + 1].start &&
                    //               _highlights[i].end > _highlights[i + 1].end) {
                    //             print("HANDLE 1");
                    //             _tempDelete.add(_highlights[i + 1]);
                    //             // _highlights.
                    //           } else {
                    //             print("HANDLE 2");
                    //             _highlights[i + 1].start = _highlights[i].end;
                    //             _highlights[i + 1].highlight = _controller.text
                    //                 .substring(_highlights[i + 1].start,
                    //                     _highlights[i + 1].end);
                    //           }
                    //         }
                    //         // break;
                    //       }
                    //       // print("CALL LEFT");

                    //     }
                    //   }
                    // }
                    // _tempDelete.forEach((element) {
                    //   _highlights.remove(element);
                    // });
                    // _highlights.sort((a, b) => a.start.compareTo(b.start));
                    // _controller.excuteHighlight(
                    //     _highlights, TextRange(start: start, end: end));
                  },
                  child: Text("GET TEXT RANGE"))
            ],
          ),
        ));
  }
}
