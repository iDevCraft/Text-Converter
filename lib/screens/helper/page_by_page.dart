import 'package:flutter/material.dart';

class PageByPage extends StatefulWidget {
  const PageByPage({super.key});

  @override
  State<PageByPage> createState() => _PageByPageState();
}

class _PageByPageState extends State<PageByPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff404040),
      body: Center(child: Text("Page By Page")),
    );
  }
}
