import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class DisplayLoadingPage extends StatefulWidget {
  const DisplayLoadingPage({super.key});

  @override
  State<DisplayLoadingPage> createState() => _DisplayLoadingPageState();
}

class _DisplayLoadingPageState extends State<DisplayLoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(),
                  TheBar(width: 90),
                  TheBar(width: 170),
                  TheBar(width: 20),
                  TheBar(width: 90),
                  TheBar(width: MediaQuery.sizeOf(context).width * 0.70),
                  TheBar(width: 70),
                  TheBar(width: 170),
                  TheBar(width: 20),
                  TheBar(width: 90),
                  TheBar(width: 20),
                  TheBar(width: 70),
                  TheBar(width: 170),
                  TheBar(width: 20),
                  TheBar(width: MediaQuery.sizeOf(context).width * 0.35),
                  TheBar(width: MediaQuery.sizeOf(context).width * 0.55),
                  TheBar(width: 70),
                  TheBar(width: 170),
                  TheBar(width: 20),
                  TheBar(width: MediaQuery.sizeOf(context).width * 0.15),
                  TheBar(width: 20),
                ],
              ))),
    ));
  }
}

class TheBar extends StatelessWidget {
  double width;
  TheBar({required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
        child: Container(
          width: width,
          height: 30,
          color: Colors.grey.withAlpha(150),
        ),
      ),
    );
  }
}
