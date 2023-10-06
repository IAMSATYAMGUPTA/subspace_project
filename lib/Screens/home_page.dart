import 'dart:async';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:subspace_project/App%20DataBase/db_helper.dart';
import 'package:subspace_project/Custom_Widget/app_custom_widget.dart';
import 'package:subspace_project/Screens/blog_detail_page.dart';
import 'package:subspace_project/Services/favourite_provider.dart';
import 'package:subspace_project/model/blogs_model.dart';
import 'package:badges/badges.dart' as badges;
import 'package:subspace_project/model/img_blob_model.dart';

import '../Services/Bloc/blogs_bloc.dart';
import 'favourite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late DBHelper dbHelper;
  List<BlogsModel> data=[];
  List<BlogsModel> favData=[];
  bool checkInt = true;

  @override
  void initState() {
    super.initState();
    context.read<BlogFavProvider>().getPrefItem();
    checkInternet();
    dbHelper = DBHelper.db;
    getData();
    getFavrouiteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: Text("All Blogs"),
        centerTitle: true,
        actions: [
          Center(
            child: badges.Badge(
             badgeContent: Consumer<BlogFavProvider>(
                 builder: (context, value, child) {
                   return Text(value.counter.toString(),style: TextStyle(color: Colors.white),);
                 },
             ),
             badgeAnimation: badges.BadgeAnimation.rotation(animationDuration: Duration(milliseconds: 300)),
             child: InkWell(
                 onTap: (){
                   if(!checkInt){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const FavouritePaage()));
                   }else{
                     CustomToast().toastMessage();
                   }
                 },
                 child: Icon(Icons.favorite,size: 35,color: Colors.white)),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: SafeArea(
        child: data.length==0 ? getApiData():getOfflineData()
      ),
    );
  }

  Widget getApiData(){
    return BlocBuilder<BlogsBloc,BlogsState>(
      builder: (context, state) {
        if(state is BlogsLoadingState){
          return Center(child: CircularProgressIndicator(),);
        } else if(state is BlogsErrorState){
          return Center(child: Text('${state.errorMsg}',style: TextStyle(color: Colors.white),),);
        } else if(state is BlogsInternetErrorState){
          return Container(color: Colors.white,child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/lottie/internet_error.json'),
              ElevatedButton(
                  onPressed: (){
                    if(!checkInt){
                      setState(() {
                        getData();
                      });
                    }else{
                      CustomToast().toastMessage();
                    }
                    },
                  child: Text("Retry",style: TextStyle(fontSize: 18),))
            ],
          ));
        }else if(state is BlogsLoadedState){
          return ListView.builder(
            itemCount: state.dataBlogsModel.blogs!.length,
            itemBuilder: (context, index) {
              var blogData = state.dataBlogsModel.blogs![index];

              bool checkFav = false;

              if(containsEqualName(favData, blogData.id!)){
                checkFav =true;
              }

              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      BlogsDetailPage(blogsModel: BlogsModel(id: blogData.id,title: blogData.title,image_url: blogData.image_url)),));
                },
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.network(blogData.image_url!,height: 30,width: 30),
                      title: Text(blogData.title!,style: TextStyle(color: Colors.white,fontSize: 17)),
                      trailing: InkWell(
                          onTap: (){
                            if(checkFav){
                              context.read<BlogFavProvider>().deleteFavBlog(blogData.id!);
                              favData.removeWhere((element) => element.id==blogData.id!);
                              context.read<BlogFavProvider>().removerCounter();
                            }else{
                              context.read<BlogFavProvider>().addFavBlog(BlogsModel(id: blogData.id,title: blogData.title,image_url: blogData.image_url));
                              favData.add(BlogsModel(id: blogData.id,title: blogData.title,image_url: blogData.image_url));
                              context.read<BlogFavProvider>().addCounter();
                            }
                            setState(() {});
                          },
                          child: checkFav? Icon(Icons.favorite,color: Colors.red.shade300,size: 35):
                          Icon(Icons.favorite_border,color: Colors.grey,size: 35)),
                    ),
                    Divider(color: Colors.grey,)
                  ],
                ),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget getOfflineData(){
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var blogData = data[index];

        bool checkFav = false;

        if(containsEqualName(favData, blogData.id!)){
          checkFav =true;
        }

        // var img = await dbHelper.getImage(blogData.id!);

        if (blogData != null) {
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  BlogsDetailPage(check: false,blogsModel: BlogsModel(id: blogData.id,title: blogData.title,image_url: blogData.image_url)),));

            },
            child: Column(
              children: [
                ListTile(
                  leading: checkInt ? Text((index+1).toString(),style: TextStyle(fontSize: 16,color: Colors.white),):Image.network(blogData.image_url!,height: 30,width: 30),
                  title: Text(blogData.title!,style: TextStyle(color: Colors.white,fontSize: 17),),
                  trailing: InkWell(
                      onTap: (){
                        if(checkFav){
                          context.read<BlogFavProvider>().deleteFavBlog(blogData.id!);
                          favData.removeWhere((element) => element.id==blogData.id!);
                          context.read<BlogFavProvider>().removerCounter();
                        }else{
                          context.read<BlogFavProvider>().addFavBlog(BlogsModel(id: blogData.id,title: blogData.title,image_url: blogData.image_url));
                          favData.add(BlogsModel(id: blogData.id,title: blogData.title,image_url: blogData.image_url));
                          context.read<BlogFavProvider>().addCounter();
                        }
                        setState(() {});
                      },
                      child: checkFav? Icon(Icons.favorite,color: Colors.red.shade300,size: 35):
                      Icon(Icons.favorite_border,color: Colors.grey,size: 35)),
                ),
                Divider(color: Colors.grey,)
              ],
            ),
          );
        } else {
          return Center(child: Text("No Data Found"),);
        }

      },
    );
  }

  // ------------------Get All Data------------------
  void getData() async{

    data = await dbHelper.fetchAllBlog();
    int i=0;

    if(data.length==0){
      context.read<BlogsBloc>().add(GetBlogsData());
    }else{
      setState(() {});
    }

  }

  // ------------------get Fav item------------------
  void getFavrouiteData() async{

    favData = await dbHelper.fetchAllFavBlog();

  }

  // ------------------check like item contain or not-----------------
  bool containsEqualName(List<BlogsModel> list, String id) {
    for (BlogsModel blog in list) {
      if (blog.id == id) {
        return true;
      }
    }
    return false;
  }

  // ------------------check internet On or Not------------------
  checkInternet()async{
    var connectivity = Connectivity();

    connectivity.onConnectivityChanged.listen((ConnectivityResult result){
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        setState(() {
          checkInt = false;
        });
      } else {
        CustomToast();
        setState(() {
          checkInt = true;
        });
      }
    });


  }



}
