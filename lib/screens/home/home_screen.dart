import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:todos/providers/home_provider.dart';
import 'package:todos/utils/colors.dart';
import 'package:todos/utils/helper.dart';

import '../../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        await InternetConnectionChecker().hasConnection.then((value) {
          if (value) {
            if (value != context.read<HomeProvider>().isInternet) {
              context.read<HomeProvider>().toggleInternet(value);
              if (context.read<HomeProvider>().isInternet) {
                context
                    .read<HomeProvider>()
                    .syncFromOfflineToOnline()
                    .then((_) {
                  context.read<HomeProvider>().fetchTodos();
                });
              }
            }
          }
        });
      } else {
        await InternetConnectionChecker().hasConnection.then((value) {
          if (!value) {
            if (value != context.read<HomeProvider>().isInternet) {
              context.read<HomeProvider>().toggleInternet(value);
              if (!context.read<HomeProvider>().isInternet) {
                context.read<HomeProvider>().fetchTodosOffline();
              }
            }
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        title: Text(
          'TO DO LIST',
          style: GoogleFonts.bebasNeue(
            fontWeight: FontWeight.bold,
            color: kOrangeColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
            icon: Icon(
              Icons.settings_outlined,
              color: kBlackColor,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              bottom: defaultPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.list,
                        color: kRedColor,
                        size: 24,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'LIST OF TODO',
                        style: GoogleFonts.bebasNeue(
                          fontWeight: FontWeight.w400,
                          color: kRedColor,
                          fontSize: 30,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Completed'),
                          value: 'completed',
                        ),
                        PopupMenuItem(
                          child: Text('Not Completed'),
                          value: 'uncompleted',
                        ),
                        PopupMenuItem(
                          child: Text('Show All'),
                          value: 'all',
                        ),
                      ];
                    },
                    onSelected: (String val) {
                      debugPrint(val.toString());
                      context.read<HomeProvider>().filterTodos(val);
                    },
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: kRedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              final todos = provider.todos;
              final isLoading = provider.isLoading;

              if (isLoading) {
                return Expanded(
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: kOrangeColor,
                    ),
                  ),
                );
              } else {
                Future<void> onRefresh() async {
                  if (context.read<HomeProvider>().isInternet) {
                    await context.read<HomeProvider>().fetchTodos();
                  } else {
                    await context.read<HomeProvider>().fetchTodosOffline();
                  }
                }

                return provider.todos.isEmpty &&
                        !provider.isLoading &&
                        provider.isCompleted
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No todos available.',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                      )
                    : _TodoList(
                        todos: todos,
                        onRefresh: onRefresh,
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  final Function onRefresh;
  final List<Todo> todos;

  const _TodoList({
    Key? key,
    required this.todos,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        color: kOrangeColor,
        onRefresh: () async {
          await onRefresh();
        },
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return _TodoItem(
              item: todos[index],
              onItemClick: () {
                Navigator.pushNamed(
                  context,
                  '/todo_detail',
                  arguments: todos[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo item;
  final Function onItemClick;

  const _TodoItem({
    Key? key,
    required this.item,
    required this.onItemClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemClick();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: !item.completed ? kRedColor : kOrangeColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  !item.completed ? Icons.timer_outlined : Icons.check_outlined,
                  color: Colors.white,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              item.description,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              '${tr('createdAt')} ${convertTimeStampToDateTimeString(item.createDate)}',
              style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
