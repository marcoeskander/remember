import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remember/shared/cubit/cubit.dart';
import 'package:remember/shared/manager/color_manager.dart';
import 'package:remember/shared/manager/font_manager.dart';
import 'package:remember/shared/manager/styles_manager.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Widget navigateBack(context) => IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: const Icon(Icons.arrow_back_ios_outlined));
void navigatAndFinsh(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
Widget defualtTextFOrmField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String? Function(String?)? validat,
  Function()? ontap,
  String? Function(String?)? onSubmit,
  bool obsecure = false,
  void Function()? suffixPressed,
  required String label,
  required Icon prefix,
  Icon? suffix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validat!,
      onTap: ontap,
      obscureText: obsecure,
      onFieldSubmitted: onSubmit,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefix,
        suffixIcon: suffix != null
            ? IconButton(
                icon: suffix,
                onPressed: suffixPressed,
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
Widget buildTaskitem({
  context,
  required Map<dynamic, dynamic> tasks,
}) =>
    Dismissible(
      background: tasks['status'] == 'new'
          ? Container(color: ColorManager.green, child: const Icon(Icons.done))
          : Container(),
      secondaryBackground: Container(
        color: ColorManager.error,
        child: const Icon(Icons.delete),
      ),
      key: Key(tasks['id'].toString()),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 15.0.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.r,
              child: Text(
                tasks['time'],
                style: getSemiBoldStyle(
                    color: ColorManager.black, fontSize: FontSize.s16),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    tasks['title'],
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s20),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  Text(
                    tasks['date'],
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s18),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          RememberCuibt.get(context).updateDataInDatabase(id: tasks['id']);
        } else {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content:
                    const Text("Are you sure you wish to delete this item?"),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () {
                        RememberCuibt.get(context).deleteRowFromDatabase(
                            tablename: 'todotasks', id: tasks['id']);
                        Navigator.of(context).pop(true);
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
        }
        return null;
      },
    );
