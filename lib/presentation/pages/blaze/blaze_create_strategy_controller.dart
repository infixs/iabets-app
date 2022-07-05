import 'package:flutter/widgets.dart';

typedef Results = List<Map<String, dynamic>>;

class BlazeCreateStrategyController extends ChangeNotifier {
  final PageController pageControllerResults = PageController();
  final Results results = [];

  void add(Map<String, dynamic> item) {
    results.add(item);
    notifyListeners();
  }

  void insert(int index, Map<String, dynamic> item) {
    results.add(item);
    notifyListeners();
  }

  int getResultIndice() => pageControllerResults.page!.toInt();

  @override
  void dispose() {
    pageControllerResults.dispose();
    super.dispose();
  }
}
