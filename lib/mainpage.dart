import 'dart:io';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:imgtopdf/colors.dart';
import 'package:imgtopdf/createpdf.dart';
import 'package:imgtopdf/home_page.dart';
import 'package:imgtopdf/list_page.dart';
import 'package:imgtopdf/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Main_Page extends StatefulWidget {
  const Main_Page({super.key});

  @override
  State<Main_Page> createState() => _Main_PageState();
}

class _Main_PageState extends State<Main_Page> {
  int pageIndex = 0;
  late List<FileSystemEntity> _folders;
  final Uri _url =
      Uri.parse('https://chiranthsh007.github.io/portfolio.github.io/');
  List<Widget> pages = [
    const Home_page(),
    const List_Page(),
  ];
  onGoBack(dynamic value) {
    getDir();
    setState(() {});
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 30.0),
          child: Text("IMG → PDF"),
        ),
        actions: [
          Row(children: [
            const Text(
              "Created by Chiranth SH",
              style: TextStyle(fontSize: 10),
            ),
            IconButton(
              icon: const Icon(FontAwesome.link),
              onPressed: () {
                _launchUrl();
              },
            ),
          ])
        ],
        backgroundColor: secondary,

        // centerTitle: true,
        elevation: 0,
      ),
      body: getBody(),
      backgroundColor: secondary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          Navigator.of(context)
              .push(
                new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const Create_pdf(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          new FadeTransition(opacity: animation, child: child),
                ),
              )
              .then(onGoBack);
        },
        child: const Icon(
          Icons.add,
          color: black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.home_rounded,
      Icons.file_copy_outlined,
    ];

    return Container(
      color: secondary,
      child: AnimatedBottomNavigationBar(
        backgroundColor: const Color(0xFF281c57),
        activeColor: Colors.yellow,
        splashColor: Colors.yellow,
        inactiveColor: Colors.blueGrey,
        icons: iconItems,
        activeIndex: pageIndex,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 25,
        iconSize: 25,
        onTap: (index) {
          selectedTab(index);
        },
      ),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Future<void> getDir() async {
    String pdfDirectory = '/storage/emulated/0/IMGtoPDFApp';
    final myDir = Directory(pdfDirectory);
    setState(() {
      _folders = myDir.listSync(recursive: true, followLinks: false);
    });
    setState(() {});
    print(_folders);
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
