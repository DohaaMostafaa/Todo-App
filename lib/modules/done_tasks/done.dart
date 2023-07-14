import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/components.dart';
import '../../../shared/cubit/cubit.dart';
import '../../../shared/cubit/states.dart';


class Done_task extends StatelessWidget {
  const Done_task({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state)
          {
              var tasks = AppCubit.get(context).doneTasks;
              return taskBuilder(tasks: tasks);
          });

  }
}
