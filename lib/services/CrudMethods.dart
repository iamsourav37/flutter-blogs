import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDMethods {
  addData(blogData) {
    FirebaseFirestore.instance.collection('blogs').add(blogData).then((value) {
      print("Data added to Firestore");
    }).catchError((onError) {
      print("error : $onError");
    });
  }

  Future<Stream<QuerySnapshot>> fetchData() async {
    return FirebaseFirestore.instance.collection('blogs').snapshots();
  }
}
