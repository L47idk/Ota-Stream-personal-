import 'package:html/dom.dart';

class HtmlParserHelpers {
  static String? getText(Element parent, String selector) {
    try {
      final element = parent.querySelector(selector);
      return element?.text.trim();
    } catch (e) {
      return null;
    }
  }

  static String? getAttribute(Element parent, String selector, String attribute) {
    try {
      final element = parent.querySelector(selector);
      return element?.attributes[attribute]?.trim();
    } catch (e) {
      return null;
    }
  }
}