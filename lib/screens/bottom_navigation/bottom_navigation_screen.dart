import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/providers/bottom_navigation_provider.dart';

import '../../utils/colors.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

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
        onPressed: () {},
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
