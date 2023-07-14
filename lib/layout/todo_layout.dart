import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createToDO(),
      child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state)
          {
            if(state is InsertToDoState)
              {
                Navigator.pop(context);
              }

          },
          builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor:Color.fromRGBO(83, 129, 198,1),
              centerTitle: true,
              title: Text('ToDo App',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                color: Color.fromRGBO(0, 0, 74, 1)),

              ),
            ),
            body: ConditionalBuilder(
              condition: state is! LoadingGetToDoState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.pink,
              onPressed: ()
              {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToToDo(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                }else {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color:Color.fromRGBO(83, 129, 198,1),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Title Must Not Be Empty';
                                  }
                                },
                                label: 'Task Title',
                                prefixIcon: Icons.title,
                                borderColor: Colors.pink,
                                textColor: Color.fromRGBO(83, 129, 198,1),
                              ),
                              SizedBox(height: 15.0,),

                              defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Time Must Not Be Empty';
                                    }
                                  },
                                  label: 'Task Time',
                                  borderColor: Colors.pink,
                                  textColor: Colors.white,
                                  prefixIcon: Icons.watch_later_outlined,
                                  onTap: () {

                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  }),

                              SizedBox(height: 15.0,),

                              defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Date Must Not Be Empty';
                                    }
                                  },
                                  label: 'Task Date',
                                  borderColor: Colors.pink,
                                  textColor: Colors.white,
                                  prefixIcon: Icons.calendar_today_outlined,
                                  onTap: () {
                                    showDatePicker(context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2023-12-31')
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });

                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value) {
                  cubit.BottomSheet(
                      isShow: false,
                      icon: Icons.edit);

                  });
                  cubit.BottomSheet(
                      isShow: true,
                      icon: Icons.add);
                }
              },
              child:Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex:cubit.currentIndex ,
              backgroundColor: Colors.white,
              selectedItemColor:Color.fromRGBO(83, 129, 198,1) ,
              onTap: (index)
              {
               cubit.ChangeIndex(index);

              },
              items:
              [
                BottomNavigationBarItem(icon:Icon(Icons.menu,color: Color.fromRGBO(83, 129, 198,1),),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(icon:Icon(Icons.check_circle_outline,color: Color.fromRGBO(83, 129, 198,1),),
                  label: 'Done',
                ),
                BottomNavigationBarItem(icon:Icon(Icons.archive_outlined,color: Color.fromRGBO(83, 129, 198,1),),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },

      ),
    );
  }


}
