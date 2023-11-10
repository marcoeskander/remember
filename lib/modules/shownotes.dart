import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/cubit/state.dart';
import 'package:remember/shared/manager/color_manager.dart';
import 'package:remember/shared/manager/font_manager.dart';
import 'package:remember/shared/manager/styles_manager.dart';

class showNote extends StatelessWidget {
  Map? model;

  showNote({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RememberCuibt, remember_State>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text(
                            "Are you sure you wish to delete this item?"),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                RememberCuibt.get(context)
                                    .deleteRowFromDatabase(
                                        tablename: 'notes', id: model!['id']);
                                Navigator.of(context).pop(false);
                              },
                              child: const Text("DELETE")),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("CANCEL"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'delete',
                  style: getBoldStyle(
                      color: ColorManager.white, fontSize: FontSize.s20),
                ),
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    model!['title']!,
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s22),
                  ),
                  SizedBox(
                    height: 25.0.h,
                  ),
                  if (model!['image'] != '' || model!['image'] != null)
                    Image(
                      image: FileImage(
                        File(model!['image']!),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
