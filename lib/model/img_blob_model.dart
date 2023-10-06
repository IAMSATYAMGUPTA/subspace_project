import 'dart:typed_data';

import '../App DataBase/db_helper.dart';

class ImageBlobModel{

  String? id;
  Uint8List image;

  ImageBlobModel({this.id,required this.image});

  factory ImageBlobModel.fromJson(Map<String,dynamic> json){
    return ImageBlobModel(
      id: json['id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      DBHelper.ID : id,
      DBHelper.IMAGE : image,
    };
  }

}