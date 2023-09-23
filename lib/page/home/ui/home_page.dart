// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_flutter/data/model/post_model.dart';
import 'package:pagination_flutter/page/home/cubit/home_cubit.dart';
import 'package:pagination_flutter/page/home/cubit/home_state.dart';
import 'package:pagination_flutter/page/home/ui/post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeCubit? cubit;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<HomeCubit>(context);
    cubit?.setFirstTime(true);
    cubit?.setLoading(true);
    cubit?.setError(false);
    cubit?.setLastPage(false);
    cubit?.setPage(0);
    cubit?.getPost();
    _scrollController = ScrollController();

    _scrollController?.addListener(() {
      if (_scrollController?.position.maxScrollExtent ==
          _scrollController?.offset) {
        cubit?.getPost();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination'),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is SuccessState) {
            List<PostModel> posts = state.posts;
            if (posts == null) {
              return const Center(
                child: Text('No post found'),
              );
            } else {
              return buildView(state.posts);
            }
          } else {
            return const Center();
          }
        },
        listener: (context, state) {
          if (state is ErrorState) {
            print(state.error);
          }
          if (state is LoadingState) {
            print('loading');
          }
          if (state is SuccessState) {
            print('success');
          }
        },
      ),
    );
  }

  buildView(List<PostModel> posts) {
    if (posts.isEmpty) {
      if (cubit!.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (cubit!.error) {
        return const Center(
          child: Text('Something went wrong'),
        );
      }
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: posts.length + (cubit!.lastPage ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == cubit!.posts.length) {
          if (cubit!.error) {
            return const Center(
              child: Text('Something went wrong'),
            );
          } else if (cubit!.lastPage) {
            return const Center();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        final PostModel postModel = cubit!.posts[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PostWidget(
            postModel.id!,
            postModel.title.toString(),
            postModel.body.toString(),
          ),
        );
      },
    );
  }
}
