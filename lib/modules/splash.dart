import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:remember/layout/remember_layout.dart';
import 'package:remember/shared/component.dart/component.dart';
import 'package:remember/shared/manager/color_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? timer;

  _startDelay() {
    timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext() {
    navigatAndFinsh(context, rememberLayout());
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Center(
          child: CircleAvatar(
              backgroundColor: ColorManager.primary,
              radius: 100.0.r,
              child: const Image(
                  image: AssetImage('assets/images/remember.png')))),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
