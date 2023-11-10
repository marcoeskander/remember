import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remember/modules/splash.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/cubit/state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RememberCuibt()..createDatabase(),
      child: BlocConsumer<RememberCuibt, remember_State>(
        builder: (context, State) {
          return const ScreenUtilInit(
            designSize: Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashView(),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
