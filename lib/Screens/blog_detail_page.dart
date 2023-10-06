import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:subspace_project/App%20DataBase/db_helper.dart';

import '../model/blogs_model.dart';

class BlogsDetailPage extends StatefulWidget {
  BlogsModel blogsModel;
  bool check;

  BlogsDetailPage({required this.blogsModel,this.check=true});

  @override
  State<BlogsDetailPage> createState() => _BlogsDetailPageState();
}

class _BlogsDetailPageState extends State<BlogsDetailPage> {

  Uint8List? img;

  @override
  void initState() {
    super.initState();
    getImage(widget.blogsModel.id);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var landScape = mediaQuery.orientation==Orientation.landscape;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: Text("Blogs Detail"),
        centerTitle: true,
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // -------------Set Blogs Text-------------------
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(widget.blogsModel.title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                subtitle: Text("\nid : "+widget.blogsModel.id!,style: TextStyle(color: Colors.white))
              ),
            ),

            // -------------Set Blogs Image------------------
            Padding(
              padding: EdgeInsets.symmetric(vertical: landScape ? 0:50),
              child: widget.check ? Image.network(widget.blogsModel.image_url!, height: landScape ?  150:250,fit: BoxFit.cover,):
              img == null ? SizedBox(): Image.memory(img!, height: landScape ?  150:250,fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  void getImage(id) async{
    try{
      var imgData = await DBHelper.db.getImage(id);
      img = imgData!;
    }catch(e){
      var imgData = await DBHelper.db.getImage('4b66e146-6da5-46e4-8a0e-2b40c0f13b0a');
      img = imgData!;
    }
    setState(() {});
  }
}
