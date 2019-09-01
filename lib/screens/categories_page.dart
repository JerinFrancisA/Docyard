import 'dart:io';

import 'package:flutter/material.dart';
import 'package:doc_yard/utilities/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:doc_yard/custom_widgets/input_box.dart';
import 'package:path/path.dart';
import 'images_page.dart';

class Categories extends StatefulWidget {
  static const routeName = 'Categories';

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int noOfCategories = 18;
  List<FileSystemEntity> categories = [];

  var inputCategoryName = InputBox();

  void createDir({@required String dirName}) async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    var dir = Directory(join(externalStorageDirectory.path, dirName));
    bool dirExists = await dir.exists();
    if (!dirExists) {
      dir.create(recursive: true);
    }
    setState(() {
      noOfCategories += 1;
    });
  }

  void setNoOfCategories() async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    var current = Directory(externalStorageDirectory.path);
    categories = current.listSync();
    noOfCategories = int.parse(categories.length.toString());
  }

  @override
  void initState() {
    setNoOfCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setNoOfCategories();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Docyard',
            style: kDocyardStyle,
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: kDocyardAppBarColor,
        ),
        body: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(
                noOfCategories,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ImagesPage(
                                dirName: categories[index].toString().substring(
                                    71, categories[index].toString().length - 1));
                          },
                        ),
                      );
                    },
                    child: GridTile(
                      child: Container(
                        decoration: BoxDecoration(
                          color: index%2 == 0? kDocyardButton1Color : kDocyardButton2Color.withOpacity(0.6),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Text(
                            categories[index].toString().substring(
                                71, categories[index].toString().length - 1),
                            style: kDocyardStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: kDocyardButton2Color,
          hoverColor: kDocyardAppBarColor,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'ADD YOUR CATEGORY HERE',
                    style: kDocyardStyle.copyWith(fontSize: 14.0),
                  ),
                  content: inputCategoryName,
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          createDir(dirName: inputCategoryName.input);
                        });
                        Navigator.pop(context);
                        initState();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: kDocyardAppBarColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'ADD CATEGORY',
                            style: kDocyardStyle.copyWith(
                                color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}