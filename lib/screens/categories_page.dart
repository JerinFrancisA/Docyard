import 'dart:io';

import 'package:flutter/material.dart';
import 'package:doc_yard/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class Categories extends StatefulWidget {
  static const routeName = 'Categories';

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<File> image;
  int noOfCategories;
  int noOfImagesInCategory;
  List<FileSystemEntity> categories;

  pickImageFrom(ImageSource source) async {
    setState(() {
      image = ImagePicker.pickImage(source: source);
    });

    Future<File> newImage;
    Directory curr = await getExternalStorageDirectory();
    await image.then((img) {
      newImage = img.copy(join(curr.path, 'A') + '/image1.png');
    });

    setState(() {
      image = newImage;
    });
  }

  Future<void> createDir({@required String dirName}) async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    var dir = Directory(join(externalStorageDirectory.path, dirName));
    bool dirExists = await dir.exists();
    if (!dirExists) {
      dir.create(recursive: true);
    }
  }

  void setNoOfCategories() async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    var current = Directory(externalStorageDirectory.path);
    categories = current.listSync();
    print(categories.length);
    noOfCategories = int.parse(categories.length.toString());
  }

  void setNoOfImagesInCategory() async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    List cat = externalStorageDirectory.listSync();
    for (var i in cat) {
      print(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    createDir(dirName: 'A');
    createDir(dirName: 'B');
    createDir(dirName: 'C');
    createDir(dirName: 'D');
    setNoOfCategories();
    setNoOfImagesInCategory();
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                pickImageFrom(ImageSource.camera);
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                pickImageFrom(ImageSource.gallery);
              },
            ),
          ],
          actionsIconTheme: IconThemeData(
            color: kDocyardBackgroundColor,
            opacity: 0.8,
          ),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(
            noOfCategories,
            (index) {
              return GridTile(
                child: Center(
                  child: Text(
                    categories[index]
                        .toString()
                        .substring(71, categories[index].toString().length - 1),
                    style: kDocyardStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
      ),
    );
  }
}

//              FutureBuilder<File>(
//                future: image,
//                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//                  if (snapshot.connectionState == ConnectionState.done &&
//                      snapshot.data != null) {
//                    return Image.file(
//                      snapshot.data,
//                      width: 300,
//                      height: 300,
//                    );
//                  } else if (snapshot.error != null) {
//                    return const Text(
//                      'Error Picking Image',
//                      textAlign: TextAlign.center,
//                    );
//                  } else {
//                    return const Text(
//                      'No Image Selected',
//                      textAlign: TextAlign.center,
//                    );
//                  }
//                },
//              )
