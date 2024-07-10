import 'package:flutter/material.dart';

class ProviderService extends ChangeNotifier {
  int _pageselectedIndex = 1;
  int get pageselected => _pageselectedIndex;

  final PageController _pageController = PageController(initialPage: 1);
  PageController get pageController => _pageController;

  set pageselected(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 5), curve: Curves.ease);
    _pageselectedIndex = index;
    notifyListeners();
  }
}
