// ignore_for_file: dead_code, camel_case_types

import 'package:flutter/material.dart';
import 'package:sandiwara/menu/categoryBerita.dart';
import 'package:sandiwara/menu/homePage.dart';
import 'package:sandiwara/topBar.dart';

class bottomNavbar extends StatefulWidget {
  const bottomNavbar({super.key});

  @override
  State<bottomNavbar> createState() => _bottomNavbarState();
}

class _bottomNavbarState extends State<bottomNavbar> {
  int currentIndex = 0;

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return const topBar();
        break;
      case 1:
        return const categoryBerita();
      default:
        return const homePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: callPage(currentIndex),
      bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: TextStyle(color: Colors.black26.withOpacity(0.15)))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            fixedColor: Colors.red[600],
            onTap: (value) {
              currentIndex = value;
              setState(() {});
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 23.0,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.grid_3x3,
                  ),
                  label: "Kategori"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                  ),
                  label: "Pencarian"),
            ],
          )),
    );
  }
}
