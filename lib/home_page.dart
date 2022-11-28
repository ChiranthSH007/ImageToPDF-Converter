import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:imgtopdf/colors.dart';
import 'package:imgtopdf/createpdf.dart';
import 'package:imgtopdf/createpdf_cam.dart';

class Home_page extends StatefulWidget {
  const Home_page({super.key});

  @override
  State<Home_page> createState() => _Home_pageState();
}

class _Home_pageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondary,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const Create_pdf(),
                      transitionsBuilder: (context, animation,
                              secondaryAnimation, child) =>
                          new FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    width: size.width / 2.5,
                    height: size.height / 5,
                    decoration: BoxDecoration(
                        color: primary,
                        border: Border.all(color: primary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          FontAwesome.file_image,
                          color: Colors.yellow,
                          size: size.width * 0.175,
                        ),
                        const Text(
                          "Images to PDF",
                          style: TextStyle(color: Colors.yellow),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreatePDF_Cam(),
                      transitionsBuilder: (context, animation,
                              secondaryAnimation, child) =>
                          new FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: size.width / 2.5,
                    height: size.height / 5,
                    decoration: BoxDecoration(
                        color: primary,
                        border: Border.all(color: primary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          FontAwesome5.camera_retro,
                          color: Colors.yellow,
                          size: size.width * 0.175,
                        ),
                        const Text(
                          "Scan to PDF",
                          style: TextStyle(color: Colors.yellow),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
