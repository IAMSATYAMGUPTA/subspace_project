import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:subspace_project/model/blogs_model.dart';

class DBHelper extends Sqflite{

  DBHelper._();

  static final DBHelper db = DBHelper._();

  static const BLOG_TABLE = 'blog';
  static const ID = 'id';
  static const IMAGE = 'image_url';
  static const TITLE = 'title';

  static const FAV_TABLE = 'favrouite';

  Database? database;

  Future<Database> getDB()async{
    if(database!=null){
      return database!;
    }else{
      return await initDB();
    }
  }

  Future<Database> initDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    var dbPath = join(documentDirectory.path,"blogs.db");

    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute("CREATE TABLE $BLOG_TABLE ($ID TEXT UNIQUE,$TITLE TEXT,$IMAGE TEXT)");
        db.execute("CREATE TABLE $FAV_TABLE ($ID TEXT UNIQUE,$TITLE TEXT,$IMAGE TEXT)");
      },
    );

  }
  
  Future<bool> addAllBlog(DataBlogsModel dataBlogsModel)async{
    
    var db = await getDB();
    int check = 0;

    for(BlogsModel blogdModel in dataBlogsModel.blogs!){
      await db.insert(BLOG_TABLE, blogdModel.toMap());
      check++;
    }


    return check>0;
    
  }

  Future<List<BlogsModel>> fetchAllBlog()async{

    var db = await getDB();

    var data = await db.query(BLOG_TABLE);

    List<BlogsModel> blogData = [];

    for(Map<String,dynamic> map in data){
      blogData.add(BlogsModel.fromJson(map));
    }

    return blogData;

  }

  Future<bool> addFavBlog(BlogsModel blogsModel)async{

    var db = await getDB();

    int check = await db.insert(FAV_TABLE, blogsModel.toMap());

    return check>0;

  }

  Future<List<BlogsModel>> fetchAllFavBlog()async{

    var db = await getDB();

    var data = await db.query(FAV_TABLE);

    List<BlogsModel> blogData = [];

    for(Map<String,dynamic> map in data){
      blogData.add(BlogsModel.fromJson(map));
    }

    return blogData;

  }

  Future<bool> removeFavBlog(String id)async{

    var db = await getDB();

    var count = await db.delete(FAV_TABLE, where: "$ID = ?",whereArgs: ['$id']);

    return count>0;

  }
  
}