import 'package:flutter/cupertino.dart';

class HighlightController extends ChangeNotifier {
  void reRenderHighlightWidget() {
    print("CALL LISTEN");
    notifyListeners();
  }
}
