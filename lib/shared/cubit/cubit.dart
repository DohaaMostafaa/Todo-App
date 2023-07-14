import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived.dart';
import 'package:todo/modules/done_tasks/done.dart';
import 'package:todo/modules/new_tasks/new.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(InitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  Database? database ;
  int currentIndex = 0;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];
  List<Widget> screens =
  [
    New_task(),
    Done_task(),
    Archived_task(),

  ];
void ChangeIndex(int index)
  {
    currentIndex = index;

    emit(NavBarState());

  }
  void createToDO()
  {
   openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database ,version)
      {
        print('Create Database');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY ,title TEXT, date TEXT,time TEXT, status TEXT )').then((value)
        {
          print('Table Created');
        }).catchError((error)
        {
          print('Error when Creating Database ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getFromToDo(database);
        print('Open Database');
      },
   ).then((value)
       {
         database = value;
         emit(CreateToDoState());
       }
   );
  }
   insertToToDo({
    required String title,
    required String time,
    required String date,
  })async
  {
     await database!.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")'
      ).then((value)
      {
        print('$value inserted');
        emit(InsertToDoState());
        getFromToDo(database);

      }).catchError((error)
      {
        print('Error when Creating Database ${error.toString()}');
      });

    });

  }

  void getFromToDo(database) async
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(LoadingGetToDoState());
     database!.rawQuery('SELECT * FROM tasks').then((value)
     {
      value.forEach((element)
      {
        if(element['status']=='new')
          newTasks.add(element);
        else  if(element['status']=='done')
          doneTasks.add(element);
        else archivedTasks.add(element);

      });
       emit(GetToDoState());
     });
  }
  void updateToDo(
  {
    required String status,
    required int id,

  })async
  {
     database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
     ).then((value) 
     {
       getFromToDo(database);
       emit(UpdateToDoState());
     });
  }

  void deleteFromToDo(
      {
        required int id,
      })async
  {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]
    ).then((value)
    {
      getFromToDo(database);
      emit(DeleteFromToDoState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void BottomSheet({
  required bool isShow,
    required IconData icon,
})
  {
    isBottomSheetShown =isShow;
    fabIcon = icon;
    emit(BottomSheetState());
  }

}