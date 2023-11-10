import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/cubit/state.dart';
import 'package:remember/shared/manager/color_manager.dart';
import 'package:remember/shared/manager/font_manager.dart';
import 'package:remember/shared/manager/styles_manager.dart';

class addNote extends StatelessWidget {
  const addNote({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    var foremKey = GlobalKey<FormState>();
    var cubit = RememberCuibt.get(context);
    return BlocConsumer<RememberCuibt, remember_State>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: () {
                    if (foremKey.currentState!.validate()) {
                      cubit.insertIntoDatabase(
                          title: textController.text,
                          time: TimeOfDay.now().toString(),
                          date: DateTime.now().toString(),
                          image: cubit.tst,
                          tablename: 'notes');
                      textController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'save',
                    style: getBoldStyle(
                        color: ColorManager.white, fontSize: FontSize.s20),
                  ),
                )
              ],
            ),
            body: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 15.0.h),
              child: Form(
                key: foremKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: textController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Title must be not empty';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'what is in your mind',
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    if (RememberCuibt.get(context).tst != null)
                      Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            height: 140.0.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                4.0.r,
                              ),
                              image: DecorationImage(
                                image: FileImage(
                                    File(RememberCuibt.get(context).tst!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 20.0.r,
                            child: IconButton(
                              onPressed: () {
                                RememberCuibt.get(context).removepostimage();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 16.0.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("choice image"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                            onPressed: () {
                                              RememberCuibt.get(context)
                                                  .ImagepostButtonPressed(
                                                      name: DateTime.now()
                                                          .toString(),
                                                      source:
                                                          ImageSource.camera);

                                              Navigator.of(context).pop(true);
                                            },
                                            child: const Text("camera")),
                                        ElevatedButton(
                                          onPressed: () {
                                            RememberCuibt.get(context)
                                                .ImagepostButtonPressed(
                                                    name: DateTime.now()
                                                        .toString(),
                                                    source:
                                                        ImageSource.gallery);
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text("gallary"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image),
                                  Text('Add photo'),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, State) {});
  }
}
