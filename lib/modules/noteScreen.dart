import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remember/modules/addnote.dart';
import 'package:remember/modules/shownotes.dart';
import 'package:remember/shared/component.dart/component.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/cubit/state.dart';
import 'package:remember/shared/manager/color_manager.dart';

class noteScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RememberCuibt, remember_State>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateTo(
                context,
                const addNote(),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: ConditionalBuilder(
            condition: RememberCuibt.get(context).notesdata.isNotEmpty,
            builder: (BuildContext context) => SingleChildScrollView(
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0.h,
                    crossAxisSpacing: 1.0.w,
                    childAspectRatio: 1 / 1.61.w,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      RememberCuibt.get(context).notesdata.length,
                      (index) => build_note_item(
                          models: RememberCuibt.get(context).notesdata[index],
                          context: context),
                    ),
                  ),
                ],
              ),
            ),
            fallback: (BuildContext context) => Container(),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}

Widget build_note_item({Map? models, context}) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 10.0.h),
      child: InkWell(
        onTap: () {
          navigateTo(
              context,
              showNote(
                model: models,
              ));
        },
        child: Card(
          child: Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
            child: Column(
              children: [
                Text(
                  models!['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.0.h,
                ),
                if (models['image'] != null || models['image'] != '')
                  Image(
                    width: 100,
                    height: 150,
                    image: FileImage(
                      File(models['image']!),
                    ),
                    fit: BoxFit.fill,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
