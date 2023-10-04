part of 'blogs_bloc.dart';

@immutable
abstract class BlogsState {}

class BlogsInitialState extends BlogsState {}

class BlogsLoadingState extends BlogsState {}

class BlogsLoadedState extends BlogsState {
  DataBlogsModel dataBlogsModel;
  BlogsLoadedState({required this.dataBlogsModel});
}

class BlogsErrorState extends BlogsState {
  String errorMsg;
  BlogsErrorState({required this.errorMsg});
}

class BlogsInternetErrorState extends BlogsState {
  String errorMsg;
  BlogsInternetErrorState({required this.errorMsg});
}
