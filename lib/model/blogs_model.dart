import 'package:subspace_project/App%20DataBase/db_helper.dart';
import 'dart:typed_data';
class BlogsModel{

  String? id;
  String? image_url;
  Uint8List? image;
  String? title;

  BlogsModel({this.id,this.image_url,this.title,this.image});

  factory BlogsModel.fromJson(Map<String,dynamic> json){
    return BlogsModel(
      id: json['id'],
      image_url: json['image_url'],
      image: json['image'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      DBHelper.ID : id,
      DBHelper.TITLE : title,
      DBHelper.IMAGE_URL : image_url,
      DBHelper.IMAGE : image,
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