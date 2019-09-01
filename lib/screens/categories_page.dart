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

  pickImageFrom(ImageSource source) {
    setState(() {
      image = ImagePicker.pickImage(source: source);
    });
  }

  Future<void> createDir({@required String dirName}) async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    var dir = Directory(join(externalStorageDirectory.path, dirName));
    print(dir.path);
    bool dirExists = await dir.exists();
    if (!dirExists) {
      dir.create(recursive: true);
    }
  }

  Future<int> noOfCategories() async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    List cat = externalStorageDirectory.listSync();
    print(cat.length);
    return cat.length;
  }

  @override
  Widget build(BuildContext context) {
    createDir(dirName: 'A');
    createDir(dirName: 'B');
    createDir(dirName: 'C');
    createDir(dirName: 'D');
    print(noOfCategories());
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
        body: Center(
          child: Column(
            children: <Widget>[
              FutureBuilder<File>(
                future: image,
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return Image.file(
                      snapshot.data,
                      width: 300,
                      height: 300,
                    );
                  } else if (snapshot.error != null) {
                    return const Text(
                      'Error Picking Image',
                      textAlign: TextAlign.center,
                    );
                  } else {
                    return const Text(
                      'No Image Selected',
                      textAlign: TextAlign.center,
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
