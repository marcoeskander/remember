import 'dart:io';
import 'package:flutter/material.dart';
import 'package:remember/modules/noteScreen.dart';
import 'package:remember/modules/todoScreen.dart';
import 'package:remember/shared/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class RememberCuibt extends Cubit<remember_State> {
  RememberCuibt() : super(init_remember_State());
  static RememberCuibt get(context) => BlocProvider.of(context);

  List<Widget> tapbar = [noteScreeen(), todoScreeen()];

  bool isbottomsheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isbottomsheetShown = isShow;
    fabIcon = icon;
    emit(change_bottomsheet_State());
  }

  late Database database;
  void createDatabase() {
    openDatabase(
      'remember.db',
      version: 1,
      onCreate: (database, version) async {
        // When creating the db, create the table
        database.execute(
            'CREATE TABLE todotasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT,status TEXT)');
        database
            .execute(
                'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT,image TEXT)')
            .then((value) {
          print('Datebase create sucessfully');
        }).catchError((error) {
          print('Datebase create error $error');
        });
      },
      onOpen: (database) {
        getDataFromDataBase(database);
      },
    ).then((value) {
      database = value;

      emit(create_Database_State());
    });
  }

  void insertIntoDatabase({
    required String title,
    required String time,
    required String date,
    required String tablename,
    String? image,
  }) async {
    database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO $tablename (title, time, date,${tablename == 'todotasks' ? 'status' : 'image'}) VALUES("$title", "$time", "$date","${tablename == 'todotasks' ? 'new' : '$image'}")')
          .then((value) {
        print('$value inerted sucessfully');
        getDataFromDataBase(database);
        emit(insertRowIn_Database_State());
      }).catchError((error) {
        print('Datebase inerted error $error');
      });
    });
  }

  List<Map<dynamic, dynamic>> newtasks = [];
  List<Map<dynamic, dynamic>> donetasks = [];
  List<Map<dynamic, dynamic>> notesdata = [];
  void getDataFromDataBase(database) async {
    newtasks = [];
    donetasks = [];
    notesdata = [];
    emit(loadingGetData_Database_State());
    database.rawQuery('SELECT * FROM todotasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else {
          donetasks.add(element);
        }
      });

      emit(gettodoData_Database_State());
    });
    database.rawQuery('SELECT * FROM notes').then((value) {
      value.forEach((element) {
        notesdata.add(element);
      });

      emit(getnoteData_Database_State());
    });
  }

  void updateDataInDatabase({required int id}) async {
    database.rawUpdate('UPDATE todotasks SET status = ?  WHERE id = ?',
        ['done', id]).then((value) {
      getDataFromDataBase(database);
      emit(updateRowIn_Database_State());
    }).catchError((error) {
      print('Datebase updated error $error');
    });
  }

  void updateDataInnoteDatabase({
    required int id,
    required String title,
    required String time,
    required String date,
    String? image,
  }) async {
    database.rawUpdate(
        'UPDATE notes SET title = ? , time = ?, date = ?, image = ?  WHERE id = ?',
        [title, time, date, image, id]).then((value) {
      getDataFromDataBase(database);
      emit(updateRowIn_noteDatabase_State());
    }).catchError((error) {
      print('Datebase updated error $error');
    });
  }

  void deleteRowFromDatabase(
      {required String tablename, required int id}) async {
    database
        .rawDelete('DELETE FROM $tablename WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(deleteRowIn_Database_State());
    }).catchError((error) {
      print('Datebase deleted error $error');
    });
  }

  File? postImage;
  final ImagePicker picker = ImagePicker();
  Future<void> ImagepostButtonPressed(
      {required ImageSource source, required String name}) async {
    tst = "";
    final pickedfile = await picker.pickImage(source: source);
    if (pickedfile != null) {
      postImage = File(pickedfile.path);
      saveImage(name: name);
      emit(getphoto_Database_State());
    } else {
      print('no image selected');
    }
  }

  File? newImage;
  String? tst;
  File? newImagess;
  void saveImage({required String name}) async {
    Directory doc = await getApplicationDocumentsDirectory();
    final String path = doc.path;
    newImage = await postImage!.copy('$path/$name.png');
    tst = newImage!.path;
    print(newImage.toString());
  }

  void removepostimage() {
    tst = null;
    emit(removephoto_Database_State());
  }
}
