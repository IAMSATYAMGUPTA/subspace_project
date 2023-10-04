import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:subspace_project/Api/api_helper.dart';
import 'package:subspace_project/Api/my_exceptions.dart';
import 'package:subspace_project/App%20DataBase/db_helper.dart';
import 'package:subspace_project/model/blogs_model.dart';

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
        DBHelper dbHelper = DBHelper.db;
        dbHelper.addAllBlog(DataBlogsModel.fromJson(data));

      }catch(e){
        if(e is FetchDataException){
          emit(BlogsInternetErrorState(errorMsg: e.ToString()));
        }else{
          emit(BlogsErrorState(errorMsg: (e as MyException).ToString()));
        }
      }
    });
  }
}
