import 'package:flutter/material.dart';
import 'package:richtext/controller/highlightController.dart';

enum TextProperties { highlight, normal }

class ObjectHighlight {
  String highlight;
  int indexSelectStart;
  Color backgroundColor;
  int indexSelectEnd;

  ObjectHighlight(
      {required this.highlight,
      required this.indexSelectStart,
      required this.indexSelectEnd,
      required this.backgroundColor});
  @override
  String toString() {
    // TODO: implement toString
    return "Highlight: $highlight , Index Start: $indexSelectStart , Index End: $indexSelectEnd";
  }
}

class ObjectForIndex {
  int start;
  int end;
  TextProperties textProperties;
  ObjectForIndex(
      {required this.start, required this.end, required this.textProperties});
  @override
  String toString() {
    // TODO: implement toString
    return "START: $start, END: $end ,HIGHLIGHT $textProperties";
  }
}

class HighlightCustom extends StatefulWidget {
  HighlightCustom(
      {super.key,
      required this.objectHighlights,
      required this.originalText,
      required this.highlightController});
  List<ObjectHighlight>? objectHighlights;
  HighlightController highlightController;

  String originalText;

  @override
  State<HighlightCustom> createState() => _HighlightCustomState();
}

class _HighlightCustomState extends State<HighlightCustom> {
  List<String> words = [
    // "CUONG",
    // "PHY",
  ];
  List<TextSpan> spans = [];

  late String originalText;
  bool noHighlight = false;

  TextSpan _highlightSpan(
      String content, String valueSemantic, dynamic backgroundColor) {
    return TextSpan(
        semanticsLabel: valueSemantic,
        text: content,
        style: TextStyle(
            backgroundColor:
                backgroundColor != null ? backgroundColor : Colors.red));
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content, style: TextStyle(color: Colors.black));
  }

  handleHighlightText() {
    Map<int, Match> allMatchesByStartIndex = <int, Match>{};
    Map<String, List<String>> _originalWords = <String, List<String>>{};
    int indexOfHighlight = 0;
    _originalWords = {};
    allMatchesByStartIndex = {};
    List<ObjectForIndex> test = [];
    List<ObjectForIndex> normalTextInHighlight = [];
    int startIndex = 0;
    spans = [];
    words = [];
    test = [];
    normalTextInHighlight = [];
    indexOfHighlight = 0;

    widget.objectHighlights?.forEach((element) {
      words.add(element.highlight);
    });
    // words = widget.highlightWords;
    originalText = widget.originalText;

    if (words.isNotEmpty) {
      // for (String word in words) {
      //   _originalWords[word] = <String>[];
      //   Iterable<Match> wordMatches = word.allMatches(originalText);
      //   for (Match match in wordMatches) {
      //     if (match[0] != null) {
      //       Match? knownMatch = allMatchesByStartIndex[match.start];
      //       if (knownMatch == null ||
      //           match[0]!.length > knownMatch[0]!.length) {
      //         _originalWords[word]!
      //             .add(originalText.substring(match.start, match.end));
      //         // test.add({a: knownMatch!);
      //         allMatchesByStartIndex[match.start] = match;

      //       }
      //     }
      //   }
      // }
      widget.objectHighlights?.forEach((element) {
        test.add(ObjectForIndex(
            start: element.indexSelectStart,
            end: element.indexSelectEnd,
            textProperties: TextProperties.highlight));
      });
      test.sort((a, b) => a.start.compareTo(b.start));
      // widget.objectHighlights?.forEach((element) {

      // });
      // test.forEach((element)=>{
      //   if(element.start != )
      // });
      if (test.isEmpty) {
        spans.add(_normalSpan(originalText.substring(startIndex, null)));
      }

      for (var i = 0; i < test.length; i++) {
        if (i + 1 < test.length) {
          normalTextInHighlight.add(ObjectForIndex(
              start: test[i].end,
              end: test[i + 1].start,
              textProperties: TextProperties.normal));
        }
      }
      test.addAll(normalTextInHighlight);
      test.sort(((a, b) => a.end.compareTo(b.end)));

      if (originalText.length > test.last.end) {
        test.add(ObjectForIndex(
            start: test.last.end,
            end: originalText.length,
            textProperties: TextProperties.normal));
        // spans.add(_normalSpan(originalText.substring(test.last.end, null)));
      }
      if (test[0].start > 0) {
        test.add(ObjectForIndex(
            start: 0,
            end: test[0].start,
            textProperties: TextProperties.normal));
        // spans.add(_normalSpan(originalText.substring(startIndex, test[0].start)));
      }

      test.sort(((a, b) => a.end.compareTo(b.end)));

      // test.forEach(((element) => spans
      //     .add(_normalSpan(originalText.substring(element.start, element.end)))));
      test.forEach((element) {
        if (element.textProperties == TextProperties.normal) {
          spans.add(
              _normalSpan(originalText.substring(element.start, element.end)));
        } else {
          Iterable<ObjectHighlight>? ss = widget.objectHighlights?.where(
              (elementHighlight) =>
                  elementHighlight.indexSelectStart == element.start);
          var temp;
          ss?.forEach((element11) {
            if (element11.indexSelectStart == element.start) {
              temp = element11.indexSelectStart;
              spans.add(_highlightSpan(
                  originalText.substring(element.start, element.end),
                  '',
                  element11.backgroundColor));
            }
          });
          if (temp != element.start) {
            spans.add(_normalSpan(
              originalText.substring(element.start, element.end),
            ));
          }
          // ignore: unrelated_type_equality_checks
        }
      });
    } else {
      spans.add(_normalSpan(originalText.substring(0, null)));
    }
    setState(() {});
  }

  @override
  void initState() {
    // handleHighlightText();
    handleHighlightText();

    widget.highlightController.addListener(() {
      handleHighlightText();
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.black), children: spans))
      ],
    ));
  }
}
