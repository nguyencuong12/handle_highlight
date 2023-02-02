import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final List<String> highlight;
  final TextStyle style;
  final TextStyle highlightStyle;
  final Color highlightColor;
  final bool ignoreCase;

  HighlightText({
    Key? key,
    required this.text,
    required this.highlight,
    required this.style,
    required this.highlightColor,
    required this.highlightStyle,
    this.ignoreCase: false,
  });

  @override
  Widget build(BuildContext context) {
    var sourceText = ignoreCase ? text.toLowerCase() : text;
    // var targetHighlight = ignoreCase ? highlight.toLowerCase() : highlight;
    List<String> targetHighlight = highlight;

    List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    for (var i = 0; i < targetHighlight.length; i++) {
      do {
        indexOfHighlight = sourceText.indexOf(targetHighlight[i], start);
        if (indexOfHighlight < 0) {
          // no highlight
          spans.add(_normalSpan(text.substring(start)));
          break;
        }
        if (indexOfHighlight > start) {
          // normal text before highlight
          spans.add(_normalSpan(text.substring(start, indexOfHighlight)));
        }
        print("INDEX $indexOfHighlight");
        if (indexOfHighlight == 12) {
          start = indexOfHighlight + targetHighlight[i].length;
          spans.add(_highlightSpan(text.substring(indexOfHighlight, start)));
          // start = indexOfHighlight + highlight.length;
        } else {
          print("CALL");
          start = indexOfHighlight + targetHighlight[i].length;
          spans.add(_normalSpan(text.substring(indexOfHighlight, start)));
        }
      } while (true);
    }
    return Text.rich(TextSpan(children: spans));
  }

  TextSpan _highlightSpan(String content) {
    return TextSpan(text: content, style: highlightStyle);
  }

  TextSpan _normalSpan(String content) {
    return TextSpan(text: content, style: style);
  }
}
