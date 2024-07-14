import 'package:flutter/material.dart';
import 'package:sketch_app/widgets/post_widget.dart';
import 'package:sketch_app/widgets/reels_item.dart';

class ReelExploreScreen extends StatelessWidget {
  final snapshot;
  const ReelExploreScreen(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ReelsItem(snapshot),
      ),
    );
  }
}