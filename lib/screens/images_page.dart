import 'dart:io';

import 'package:doc_yard/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImagesPage extends StatefulWidget {
  static const routeName = 'ImagesPage';

  ImagesPage({@required this.dirName});

  final dirName;

  @override
  _ImagesPageState createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  Future<File> image;
  List imagesList;
  int noOfImages = 1;

  pickImageFrom(ImageSource source) async {
    setState(() {
      image = ImagePicker.pickImage(source: source);
    });

    setNoOfImagesInCategory(widget.dirName);
    Future<File> newImage;
    Directory curr = await getExternalStorageDirectory();
    await image.then((img) {
      newImage = img.copy(
          join(curr.path, widget.dirName) + '/image$noOfImages.png');
    });

    setState(() {
      image = newImage;
    });
  }

  void setNoOfImagesInCategory(String dirName) async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    var subFolder = Directory(externalStorageDirectory.path + '/$dirName');
    imagesList = subFolder.listSync();
    for (var i in imagesList) {
      print(i.toString());
    }
    setState(() {
      noOfImages = imagesList.length;
    });
    print(noOfImages);
  }

  @override
  void initState() {
    setNoOfImagesInCategory(widget.dirName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setNoOfImagesInCategory(widget.dirName);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Images',
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(
              imagesList.length ?? 18,
              (index) {
                return GridTile(
                  child: Container(
                    decoration: BoxDecoration(
                      color: imagesList.length % 2 == 0 ? kDocyardButton1Color : kDocyardButton2Color,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Image.file(
                      imagesList[index],
                      fit: BoxFit.cover,
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
    );
  }
}

//FutureBuilder<File>(
////                    future: imagesList[index],
//builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//if (snapshot.connectionState == ConnectionState.done &&
//snapshot.data != null) {
//return Image.memory(
//imagesList[index],
//width: 300,
//height: 300,
//);
//} else if (snapshot.error != null) {
//return const Text(
//'Error Picking Image',
//textAlign: TextAlign.center,
//);
//} else {
//return const Text(
//'No Image Selected',
//textAlign: TextAlign.center,
//);
//}
//},
//)
