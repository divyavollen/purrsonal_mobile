import 'package:flutter/material.dart';

class SheetItem {
  Widget leading;
  Text title;
  void Function() onTap;
  EdgeInsetsGeometry padding;

  SheetItem({
    required this.leading,
    required this.title,
    required this.onTap,
    required this.padding,
  });
}
