import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todos/providers/home_provider.dart';
import 'package:todos/utils/colors.dart';
import 'package:todos/utils/helper.dart';

import '../../models/todo.dart';
import '../widgets.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  GlobalKey<FormState> editTodoFormKey = GlobalKey<FormState>();

  Future<void> deleteTodo(String uid) async {
    try {
      await context.read<HomeProvider>().deleteTodo(uid).then(
        (value) {
          if (value) {
            context.read<HomeProvider>().deleteTodoOffline(uid);
            Navigator.pop(context);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kBlackColor,
                content: Text(
                  'Delete TODO successfully.',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                  ),
                ),
              ),
            );
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: kBlackColor,
                content: Text(
                  'Delete TODO failed, please try again.',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: kRedColor,
                  ),
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  void openDialogDeleteTodo(String uid) {
    showDialog(
        context: context,
        builder: ((context) {
          return Scaffold(
            backgroundColor: kBlackColor.withOpacity(0.5),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  onPressed: () {
                    deleteTodo(uid);
                  },
                  title: 'Delete TODO',
                  backgroundColor: Colors.white,
                  textColor: Colors.red,
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: 'Cancel',
                  backgroundColor: Colors.white,
                  textColor: Color(0xFF00FF19).withOpacity(0.5),
                ),
              ],
            ),
          );
        }));
  }

  void completeTodo(String uid) {
    context.read<HomeProvider>().completeTodo(uid).then((_) {
      Navigator.pop(context);
    });
  }

  Future<void> doEditTodo(String uid, title, description) async {
    try {
      await context
          .read<HomeProvider>()
          .editTodo(
            uid,
            title,
            description,
            Timestamp.fromDate(DateTime.now()),
          )
          .then(
        (_) {
          Navigator.pop(context);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  void editTodo(String uid) {
    if (!editTodoFormKey.currentState!.validate()) {
      return;
    } else {
      doEditTodo(uid, titleController.text, descriptionController.text);
    }
  }

  void showBottomSheetEditTodo(String uid, title, description) {

    titleController.text = title;
    descriptionController.text = description;

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
                key: editTodoFormKey,
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
                      title: 'Edit TODO',
                      onPressed: () {
                        editTodo(uid);
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
    final args = ModalRoute.of(context)!.settings.arguments as Todo;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
          ),
        ),
        actions: [
          !args.completed
              ? IconButton(
                  onPressed: () {
                    completeTodo(args.uid);
                  },
                  icon: Icon(
                    Icons.check_outlined,
                    color: kBlackColor,
                  ),
                )
              : const SizedBox(),
          !args.completed
              ? IconButton(
                  onPressed: () {
                    showBottomSheetEditTodo(args.uid, args.title, args.description);
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: kBlackColor,
                  ),
                )
              : const SizedBox(),
          IconButton(
            onPressed: () {
              openDialogDeleteTodo(args.uid);
            },
            icon: Icon(
              Icons.delete_outline,
              color: kBlackColor,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding,
            ),
            child: Text(
              args.title,
              style: GoogleFonts.bebasNeue(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                color: kBlackColor,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Text(
                args.description,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: kBlackColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding,
            ),
            child: Text(
              'Created at ${convertTimeStampToDateTimeString(args.createDate)}',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: kBlackColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
