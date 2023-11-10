import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:remember/shared/component.dart/component.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/cubit/state.dart';
import 'package:remember/shared/manager/color_manager.dart';

class todoScreeen extends StatelessWidget {
  const todoScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    var scafffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();
    var textController = TextEditingController();
    var dateController = TextEditingController();
    var timeController = TextEditingController();
    var cubit = RememberCuibt.get(context);
    return BlocConsumer<RememberCuibt, remember_State>(
      builder: (context, State) {
        return Scaffold(
          key: scafffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isbottomsheetShown) {
                if (formKey.currentState!.validate()) {
                  cubit.insertIntoDatabase(
                      title: textController.text,
                      time: timeController.text,
                      date: dateController.text,
                      tablename: 'todotasks');
                  textController.clear();
                  dateController.clear();
                  timeController.clear();
                  Navigator.pop(context);
                }
                cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
              } else {
                scafffoldKey.currentState!
                    .showBottomSheet((context) => Container(
                          decoration: BoxDecoration(
                            color: ColorManager.gray,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                15.r,
                              ),
                              topRight: Radius.circular(
                                15.r,
                              ),
                            ),
                          ),
                          child: SingleChildScrollView(
                              child: Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0.w, vertical: 10.0.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defualtTextFOrmField(
                                      controller: textController,
                                      keyboardType: TextInputType.text,
                                      validat: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Title must be not empty';
                                        }
                                        return null;
                                      },
                                      label: 'Title',
                                      prefix: const Icon(Icons.title)),
                                  SizedBox(
                                    height: 15.0.h,
                                  ),
                                  defualtTextFOrmField(
                                      controller: timeController,
                                      keyboardType: TextInputType.datetime,
                                      validat: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Time must be not empty';
                                        }
                                        return null;
                                      },
                                      ontap: () {
                                        showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                        });
                                      },
                                      label: 'Time',
                                      prefix: const Icon(
                                          Icons.watch_later_rounded)),
                                  SizedBox(
                                    height: 15.0.h,
                                  ),
                                  defualtTextFOrmField(
                                      controller: dateController,
                                      keyboardType: TextInputType.datetime,
                                      validat: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Date must be not empty';
                                        }
                                        return null;
                                      },
                                      ontap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2030-12-31'),
                                        ).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                      label: 'Date',
                                      prefix:
                                          const Icon(Icons.date_range_sharp)),
                                ],
                              ),
                            ),
                          )),
                        ))
                    .closed
                    .then((value) {
                  cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                }).catchError((error) {
                  print('bottom sheet error is $error');
                });
                cubit.changeBottomSheet(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          body: State is! loadingGetData_Database_State
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildTaskitem(
                                context: context,
                                tasks: cubit.newtasks[index],
                              ),
                          separatorBuilder: (context, index) => Container(
                                color: ColorManager.gray,
                                height: 1.2.h,
                                width: double.infinity,
                              ),
                          itemCount: cubit.newtasks.length),
                      SizedBox(
                        height: 25.0.h,
                      ),
                      if (cubit.donetasks.isNotEmpty)
                        Divider(
                          color: ColorManager.gray,
                        ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      if (cubit.donetasks.isNotEmpty)
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => buildTaskitem(
                                  context: context,
                                  tasks: cubit.donetasks[index],
                                ),
                            separatorBuilder: (context, index) => Container(
                                  color: ColorManager.gray,
                                  height: 1.2.h,
                                  width: double.infinity,
                                ),
                            itemCount: cubit.donetasks.length),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
      listener: (context, State) {},
    );
  }
}
