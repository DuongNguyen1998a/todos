import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:todos/providers/bottom_navigation_provider.dart';
import 'package:todos/providers/home_provider.dart';
import 'package:todos/utils/helper.dart';

import '../../utils/colors.dart';
import '../widgets.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> addTodoFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addTodo() {
    if (!addTodoFormKey.currentState!.validate()) {
      return;
    } else {
      doAddTodo(titleController.text, descriptionController.text);
    }
  }

  Future<void> doAddTodo(String title, description) async {
    try {
      await InternetConnectionChecker().hasConnection.then((value) async {
        if (value) {
          await context
              .read<BottomNavigationProvider>()
              .addTodo(title, description)
              .then(
            (value) {
              context
                  .read<BottomNavigationProvider>()
                  .addTodoOffline(value, title, description);
              Navigator.pop(context);
              context.read<HomeProvider>().fetchTodos().then(
                (_) {
                  titleController.text = '';
                  descriptionController.text = '';
                },
              );
            },
          );
        } else {
          await context
              .read<BottomNavigationProvider>()
              .addTodoOffline(null, title, description)
              .then(
            (_) {
              Navigator.pop(context);
              context.read<HomeProvider>().fetchTodosOffline().then(
                (_) {
                  titleController.text = '';
                  descriptionController.text = '';
                },
              );
            },
          );
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  void showBottomSheetAddTodo() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: kOrangeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                  defaultPadding, defaultPadding, defaultPadding, 0),
              child: Form(
                key: addTodoFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 80,
                        height: 6,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextField(
                      textController: titleController,
                      hintText: 'Title',
                      cursorColor: Colors.white,
                      hintColor: Colors.white,
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomTextField(
                      textController: descriptionController,
                      hintText: 'Description',
                      maxLines: 8,
                      cursorColor: Colors.white,
                      hintColor: Colors.white,
                      textInputAction: TextInputAction.newline,
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    CustomButton(
                      title: 'Add TODO',
                      onPressed: () {
                        addTodo();
                      },
                      backgroundColor: Colors.white,
                      textColor: kOrangeColor,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).whenComplete(() {
      titleController.text = '';
      descriptionController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
          return IndexedStack(
            index: provider.selectedIndex,
            children: provider.screens,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kRedColor,
        onPressed: () {
          showBottomSheetAddTodo();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: kRedColor,
        shape: CircularNotchedRectangle(), //shape of notch
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<BottomNavigationProvider>().onChangeScreen(0);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<BottomNavigationProvider>().onChangeScreen(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
