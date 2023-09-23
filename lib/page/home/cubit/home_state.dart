import 'package:pagination_flutter/data/model/post_model.dart';

abstract class HomeState {}

class LoadingState extends HomeState {}

class SuccessState extends HomeState {
  List<PostModel> posts;
  SuccessState(this.posts);
}

class ErrorState extends HomeState {
  String error;
  ErrorState(this.error);
}
