import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/cubit/state.dart';
import 'package:remember/shared/manager/color_manager.dart';
import 'package:remember/shared/manager/font_manager.dart';
import 'package:remember/shared/manager/styles_manager.dart';

class rememberLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RememberCuibt, remember_State>(
      builder: (context, State) {
        var cubit = RememberCuibt.get(context);
        return DefaultTabController(
          length: cubit.tapbar.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Remember',
                style: getBoldStyle(
                    color: ColorManager.primary, fontSize: FontSize.s24),
              ),
              elevation: 0.2,
              centerTitle: true,
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.note), text: 'note'),
                Tab(icon: Icon(Icons.task_sharp), text: 'tasks'),
              ]),
            ),
            body: TabBarView(
              children: cubit.tapbar,
            ),
          ),
        );
      },
      listener: (context, State) {},
    );
  }
}
