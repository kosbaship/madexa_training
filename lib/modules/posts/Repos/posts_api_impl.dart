import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:training_task1/modules/posts/Repos/posts_repo.dart';
import 'package:training_task1/modules/posts/models/post_model.dart';

import '../../../core/Error/Failure.dart';
import '../../../shared/network/remote/dio_helper.dart';

class PostsAPI extends PostsRepo {
  @override
  Future<Either<Failure, List<PostModel>>> getAllPosts() async {
    try {
      final posts = <PostModel>[];
      final postsResponse = await DioHelper.getData(url: 'posts');

      for (var post in postsResponse.data) {
        posts.add(PostModel.fromJson(post));
      }

      return Right(posts);
    } catch (error) {
      if (error is DioException) {
        return Left(ServerFailure.fromDioException(error));
      } else {
        return Left(ServerFailure(errMessage: error.toString()));
      }
    }
  }
}
