import 'package:flutter/cupertino.dart';
import 'package:subspace_project/App%20DataBase/db_helper.dart';
import 'package:subspace_project/model/blogs_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogFavProvider extends ChangeNotifier{

  DBHelper dbHelper = DBHelper.db;

  List<BlogsModel> blogData = [];

  int _counter = 0;
  int get counter => _counter;

  void addFavBlog(BlogsModel blogsModel){
    dbHelper.addFavBlog(blogsModel);
    fetchAllFavBlog();
  }

  void fetchAllFavBlog()async{
    blogData = await dbHelper.fetchAllFavBlog();
    notifyListeners();
  }

  void deleteFavBlog(String id){
    dbHelper.removeFavBlog(id);
    fetchAllFavBlog();
  }

  void _setPrefItem()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("fav_item", _counter);
    notifyListeners();
  }

  void getPrefItem()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _counter = preferences.getInt("fav_item") ?? 0 ;
    notifyListeners();
  }

  void addCounter(){
    _counter++;
    _setPrefItem();
  }

  void removerCounter(){
    _counter--;
    _setPrefItem();
  }

}