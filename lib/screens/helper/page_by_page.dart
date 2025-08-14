import 'package:flutter/material.dart';
import 'package:text_converter/helper/string_images.dart';

class PageByPage extends StatefulWidget {
  const PageByPage({super.key});

  @override
  State<PageByPage> createState() => _PageByPageState();
}

class _PageByPageState extends State<PageByPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: Center(child: Text("Page By Page")),
    );
  }
}
