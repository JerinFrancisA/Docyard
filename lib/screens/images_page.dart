import 'dart:io';

import 'package:doc_yard/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

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
      newImage =
          img.copy(join(curr.path, widget.dirName) + '/image$noOfImages.png');
    });

    setState(() {
      image = newImage;
    });
  }

  void setNoOfImagesInCategory(String dirName) async {
    Directory externalStorageDirectory = await getExternalStorageDirectory();
    var subFolder = Directory(externalStorageDirectory.path + '/$dirName');
    imagesList = subFolder.listSync();
    setState(() {
      noOfImages = imagesList.length;
    });
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
            widget.dirName,
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
                return GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'CHOOSE OPTION',
                            style: kDocyardStyle.copyWith(
                                fontSize: 14.0, fontWeight: FontWeight.w700),
                          ),
                          actions: <Widget>[
                            Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    Directory externalStorageDirectory =
                                        await getExternalStorageDirectory();
                                    Directory dir =
                                    await getApplicationDocumentsDirectory();
                                    print(dir.path);
                                    FlutterShareFile.shareImage(
                                        '/storage/emulated/0/Android/data/com.fawcis.doc_yard/files/${widget.dirName}',
                                        imagesList[index]
                                            .toString()
                                            .replaceAll(
                                                (externalStorageDirectory.path +
                                                    '/${widget.dirName}/'),
                                                '')
                                            .replaceAll('File: \'', '')
                                            .replaceAll('\'', ''));
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: kDocyardAppBarColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        'SHARE',
                                        style: kDocyardStyle.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () async {
                                    Directory imagePath = Directory(
                                        imagesList[index]
                                            .toString()
                                            .replaceAll('File: \'', '')
                                            .replaceAll('\'', ''));
                                    setState(() {
                                      imagePath.deleteSync(recursive: true);
                                      imageCache.clear();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: kDocyardAppBarColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        'DELETE',
                                        style: kDocyardStyle.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    FlutterWebBrowser.openWebPage(
                                        url:
                                            'https://fotoram.io/editor/#resize',
                                        androidToolbarColor:
                                            Colors.indigo.shade600);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: kDocyardAppBarColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        'RESIZE',
                                        style: kDocyardStyle.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: kDocyardAppBarColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: Text(
                                        'DISMISS',
                                        style: kDocyardStyle.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          backgroundColor: kDocyardBackgroundColor,
                        );
                      },
                    );
                  },
                  child: GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        color: imagesList.length % 2 == 0
                            ? kDocyardButton1Color
                            : kDocyardButton2Color,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Image.file(
                        imagesList[index],
                        fit: BoxFit.cover,
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
    );
  }
}
