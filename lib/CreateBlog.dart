import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'services/CrudMethods.dart';

class CreateBlog extends StatefulWidget {
  static const String ID = "create_blog_page";
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName, title, desc;
  File _selectedImage;
  String downloadFileURL;
  bool isLoading = false;
  CRUDMethods crudMethods = CRUDMethods();

  Future<void> getImage() async {
    await ImagePicker().getImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _selectedImage = File(value.path);
      });
    });
    log("Image selected, $_selectedImage");
  }

  uploadPicture() {
    if (_selectedImage != null) {
      setState(() {
        this.isLoading = true;
      });
      String fileName = Path.basename(_selectedImage.path);
      Reference reference =
          FirebaseStorage.instance.ref().child("blogImages/").child(fileName);

      UploadTask uploadTask = reference.putFile(_selectedImage);

      uploadTask.whenComplete(() async {
        log("file uploaded");
        await reference
            .getDownloadURL()
            .then((value) => downloadFileURL = value);
        log("Download URL : $downloadFileURL");

        crudMethods.addData({
          'imageURL': downloadFileURL,
          'authorName': authorName,
          'title': title,
          'description': desc
        });
        Navigator.pop(context);
      });
    } else {
      log("ERROR : please choose an image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.white,
              ),
            ),
            Text(
              "Blogs",
              style: TextStyle(
                fontSize: 25.0,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 4.0),
            child: IconButton(
              // upload button
              icon: Icon(
                Icons.upload_sharp,
                size: 25.0,
              ),
              onPressed: () {
                uploadPicture();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(7),
                    height: 200.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: _selectedImage != null
                        ? Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.file(
                                _selectedImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                color: Colors.black45,
                                size: 40.0,
                              ),
                              onPressed: () {
                                this.getImage();
                              },
                            ),
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            this.authorName = value;
                          },
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          cursorWidth: 3.3,
                          decoration: InputDecoration(
                            hintText: 'Author Name',
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          onChanged: (value) {
                            this.title = value;
                          },
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          cursorWidth: 3.3,
                          decoration: InputDecoration(
                            hintText: 'Title',
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          onChanged: (value) {
                            this.desc = value;
                          },
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                          cursorWidth: 3.3,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Description ',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
