import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog_project/CreateBlog.dart';
import 'services/CrudMethods.dart';
import 'DetailsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CRUDMethods crudMethods = CRUDMethods();
  Stream blogsStream;

  @override
  void initState() {
    super.initState();
    crudMethods.fetchData().then((value) {
      setState(() {
        blogsStream = value;
      });
    });
  }

  Widget blogsList() {
    return Container(
      margin: EdgeInsets.only(bottom: 70.0),
      child: StreamBuilder(
        stream: blogsStream,
        builder: (context, snapshot) {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data.docs[index];
              return BlogsTile(
                  authorName: data['authorName'],
                  desc: data['description'],
                  imgUrl: data['imageURL'],
                  title: data['title']);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log("Home Page build method called");
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateBlog.ID);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: blogsStream != null
          ? blogsList()
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  final String imgUrl, authorName, title, desc;
  BlogsTile(
      {@required this.authorName,
      @required this.desc,
      @required this.imgUrl,
      @required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("tapped");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
                authorName: authorName,
                desc: desc,
                imgUrl: imgUrl,
                title: title),
          ),
        );
      },
      child: Container(
        height: 220.0,
        margin: EdgeInsets.only(bottom: 10.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              height: 220.0,
              decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.5),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    authorName,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
