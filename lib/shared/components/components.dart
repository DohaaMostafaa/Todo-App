import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  double radius = 20.0,
  bool isUpperCase = true,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String? value) validate,
  required String label,
  required IconData? prefixIcon,
  IconData? suffixIcon,
  VoidCallback? suffixPressed,
  Function(String)? onSubmit,
  bool isPassword = false,
  VoidCallback? onTap,
  String? Function(String? value)? onChanged,
  Color borderColor = Colors.blue,
  Color textColor = Colors.white,
}) =>
    TextFormField(
      style: TextStyle(color: textColor),
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      onChanged: onChanged,
      validator: validate,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintStyle:TextStyle(color: Colors.white) ,
        prefixIcon: Icon(prefixIcon),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: suffixPressed,
        ),
      ),
    );

Widget buildTextItem(context, Map model) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            Text(
              '${model['time']}',
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(83, 129, 198,1),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromRGBO(0, 0, 74, 1),
                  ),
                  width: 260.0,
                  height: 80.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 75.0,),

                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              '${model['title']}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              '${model['date']}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        width: 50.0,
                      ),

                      IconButton(
                          onPressed: () {
                            AppCubit.get(context)
                                .updateToDo(status: 'done', id: model['id']);
                          },
                          icon: const Icon(
                            Icons.check_box,
                            color: Colors.pink,
                          )),

                      IconButton(
                        onPressed: () {
                          AppCubit.get(context)
                              .updateToDo(status: 'archive', id: model['id']);
                        },
                        icon: const Icon(
                          Icons.archive,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text(
                    'Delete Task',
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 0, 74, 1),
                    ),
                  ),
                  content: const Text(
                    'Are You Sure That You Want To Delete This Task?',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 74, 1),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes')),
                  ],
                ));
      },
      onDismissed: (direction) {
        AppCubit.get(context).deleteFromToDo(
          id: model['id'],
        );
      },
    );

Widget taskBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => Container(
        color:  Colors.white,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return buildTextItem(context, tasks[index]);
            },
            separatorBuilder: (context, index) => myDivider(),
            itemCount: tasks.length),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu,
              color: const Color.fromRGBO(0, 0, 74, 1),
              size: 100.0,
            ),
            const Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color.fromRGBO(0, 0, 74, 1),
              ),
            ),
          ],
        ),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 1.0,
        color: Colors.grey,
      ),
    );


void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
