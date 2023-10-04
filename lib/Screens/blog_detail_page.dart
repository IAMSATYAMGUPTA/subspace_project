import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../model/blogs_model.dart';

class BlogsDetailPage extends StatelessWidget {
  BlogsModel blogsModel;
  BlogsDetailPage({required this.blogsModel});

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
                title: Text(blogsModel.title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                subtitle: Text("\nid : "+blogsModel.id!,style: TextStyle(color: Colors.white))
              ),
            ),

            // -------------Set Blogs Image------------------
            Padding(
              padding: EdgeInsets.symmetric(vertical: landScape ? 0:50),
              child: Image.network(blogsModel.image_url!, height: landScape ?  150:250,fit: BoxFit.cover,),
            ),
          ],
        ),
      ),
    );
  }
}
