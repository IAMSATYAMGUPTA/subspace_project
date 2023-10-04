import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subspace_project/Services/favourite_provider.dart';

class FavouritePaage extends StatefulWidget {
  const FavouritePaage({Key? key}) : super(key: key);

  @override
  State<FavouritePaage> createState() => _FavouritePaageState();
}

class _FavouritePaageState extends State<FavouritePaage> {

  @override
  void initState() {
    super.initState();
    context.read<BlogFavProvider>().fetchAllFavBlog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: Text("Favrouite Blogs"),
        centerTitle: true,
      ),
      body: Consumer<BlogFavProvider>(
          builder: (context, value, child) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 8),
              itemCount: value.blogData.length,
              itemBuilder: (context, index) {
                var blogData = value.blogData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(blogData.image_url!,height: 200,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                      child: Text(blogData.title!,
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16,),textAlign: TextAlign.center,),
                    ),
                    Divider(color: Colors.grey)
                  ],
                );
              },
            );
          },
      ),
    );
  }

}
