import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subspace_project/Api/api_helper.dart';
import 'package:subspace_project/Api/my_exceptions.dart';
import 'package:subspace_project/App%20DataBase/db_helper.dart';
import 'package:subspace_project/model/blogs_model.dart';
import 'package:http/http.dart' as http;
import 'package:subspace_project/model/img_blob_model.dart';

part 'blogs_event.dart';
part 'blogs_state.dart';

class BlogsBloc extends Bloc<BlogsEvent, BlogsState> {
  BlogsBloc() : super(BlogsInitialState()){
    on<GetBlogsData>((event, emit) async{
      emit(BlogsLoadingState());
      try{
        var data = await ApiHelper().getBlogData();
        emit(BlogsLoadedState(dataBlogsModel: DataBlogsModel.fromJson(data)));

        //--------------Manage offline Data----------------------
        List<BlogsModel> blogData =[];
        for(Map<String,dynamic> map in data['blogs']){
          blogData.add(BlogsModel.fromJson(map));
        }

        DBHelper dbHelper = DBHelper.db;
        dbHelper.addAllBlog(DataBlogsModel.fromJson(data));

        for (BlogsModel blog in blogData) {
          final response = await http.get(Uri.parse(blog.image_url!));
          final List<int> bytes = response.bodyBytes;
          final imageBlob = Uint8List.fromList(bytes);
          await dbHelper.saveImage(ImageBlobModel(id: blog.id!, image: imageBlob));
        }


      }catch(e){
        if(e is FetchDataException){
          emit(BlogsInternetErrorState(errorMsg: e.ToString()));
        }else{
          emit(BlogsErrorState(errorMsg: (e as MyException).ToString()));
        }
      }
    });

    // Future<Uint8List> downloadImageToBlob(String imageUrl) async {
    //   final response = await http.get(Uri.parse(imageUrl));
    //   if (response.statusCode == 200) {
    //     final List<int> bytes = response.bodyBytes;
    //     return Uint8List.fromList(bytes);
    //   } else {
    //     throw Exception('Failed to download image');
    //   }
    // }

  }
}
