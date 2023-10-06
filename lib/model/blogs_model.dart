import 'package:subspace_project/App%20DataBase/db_helper.dart';
import 'dart:typed_data';
class BlogsModel{

  String? id;
  String? image_url;
  String? title;

  BlogsModel({this.id,this.image_url,this.title});

  factory BlogsModel.fromJson(Map<String,dynamic> json){
    return BlogsModel(
      id: json['id'],
      image_url: json['image_url'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      DBHelper.ID : id,
      DBHelper.TITLE : title,
      DBHelper.IMAGE_URL : image_url,
    };
  }

}

class DataBlogsModel{

  List<BlogsModel>? blogs;

  DataBlogsModel({this.blogs});

  factory DataBlogsModel.fromJson(Map<String,dynamic> json){

    List<BlogsModel> mBlogs = [];

    for(Map<String,dynamic> data in json['blogs']){
      mBlogs.add(BlogsModel.fromJson(data));
    }

    return DataBlogsModel(
        blogs: mBlogs
    );

  }

}