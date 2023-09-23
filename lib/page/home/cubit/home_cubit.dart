// ignore_for_file: unused_field, avoid_print, unrelated_type_equality_checks

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_flutter/data/model/post_model.dart';
import 'package:pagination_flutter/data/repository/home_repository.dart';
import 'package:pagination_flutter/page/home/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(LoadingState());

  bool? _loading;
  bool? _error;
  bool? _lastPage;
  bool? _firstTime;
  int? _page;
  final int _limit = 5;
  final List<PostModel> _posts = [];

  bool get loading => _loading!;
  bool get error => _error!;
  bool get lastPage => _lastPage!;
  bool get firstTime => _firstTime!;
  List<PostModel> get posts => _posts;

  setFirstTime(value) {
    _firstTime = value;
  }

  setLoading(value) {
    _loading = value;
  }

  setError(value) {
    _error = value;
  }

  setLastPage(value) {
    _lastPage = value;
  }

  setPage(value) {
    _page = value;
  }

  getPost() async {
    if (_firstTime == true) {
      emit(LoadingState());
      _firstTime = false;
    }

    if (_lastPage == true || _lastPage == _posts.length) {
      return;
    }
    try {
      final result = await HomeRepository.getPostRepository(_page!, _limit);
      List<dynamic> resultList = result as List<dynamic>;
      List<PostModel> newPost =
          resultList.map((e) => PostModel.fromJson(e)).toList();
      _posts.addAll(newPost);
      print('$_posts ---->>>');
      _loading = false;
      _error = false;
      _lastPage = newPost.length < _limit;
      if (_page == 0) {
        _page = 1;
      }
      _page = _page! + 1;
      if (newPost.isEmpty) {
        _lastPage = true;
      }
      emit(SuccessState(_posts));
    } catch (error) {
      _error = true;
      _loading = false;
      emit(ErrorState(error.toString()));
    }
  }
}
