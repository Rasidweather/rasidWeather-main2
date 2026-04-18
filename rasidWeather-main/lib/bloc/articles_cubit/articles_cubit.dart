import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/article_home_model.dart';
import '../../data/model/article_model.dart';
import '../../data/model/base/api_response.dart';
import '../../data/model/comment_model.dart';
import '../../data/repository/articles_repo.dart';

part 'articles_state.dart';

enum ArticlesType { latest, featured, top }

class ArticlesBloc extends Cubit<ArticlesState> {
  ArticlesBloc(this.articlesRepo) : super(ArticlesInitial());
  final ArticlesRepo articlesRepo;

  final List<ArticleModel> _articles = <ArticleModel>[];
  final List<ArticleModel> _bookmarks = <ArticleModel>[];
  final List<CommentModel> _articleComments = <CommentModel>[];

  Future<void> getHomeArticles({String? countryCode}) async {
    String? params = '';
    if (countryCode != null) {
      params = '?country_code=$countryCode';
    }

    emit(ArticlesHomeLoading());
    try {
      final ApiResponse apiResponse = await articlesRepo.getArticleHome(params);
      final List<ArticleHomeModel> articlesHome = List<ArticleHomeModel>.from(
          (apiResponse.response!.data['body'] as Iterable).map((x) => ArticleHomeModel.fromJson(x as Map<String, dynamic>)));
      emit(ArticlesHomeSuccess(articlesHome));
    } catch (e) {
      emit(ArticlesHomeError(e.toString()));
    }
  }

  Future<void> getArticles(
      {String? categories, String? onlyVideo, String? countryCode, bool refresh = false, ArticlesType? type, int currentPage = 1}) async {
    emit(ArticlesLoading(refresh: currentPage == 1, loading: currentPage > 1));
    String params = '?page=$currentPage';
    if (type != null) {
      switch (type) {
        case ArticlesType.latest:
          params += '&type=latests';
        case ArticlesType.featured:
          params += '&type=featureds';
        case ArticlesType.top:
          params += '&type=tops';
      }
    }
    if (countryCode != null) {
      params += '&country_code=$countryCode';
    }
    if (onlyVideo != null) {
      params += '&only_video=$onlyVideo';
    }

    if (categories != null) {
      params += '&categories=$categories';
    }

    try {
      if (currentPage == 1) {
        _articles.clear();
      }
      final ApiResponse apiResponse = await articlesRepo.getArticles(params);
      final ArticleModelBody articles = ArticleModelBody.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      _articles.addAll(articles.data!);
      emit(ArticlesSuccess(_articles, isLastPage: articles.meta!.lastPage == articles.meta!.currentPage));
    } catch (e) {
      emit(ArticlesError(e.toString()));
    }
  }

  Future<void> getBookmarks({int currentPage = 1}) async {
    emit(BookmarksLoading(refresh: currentPage == 1, loading: currentPage > 1));
    final String params = '?page=$currentPage';

    try {
      if (currentPage == 1) {
        _bookmarks.clear();
      }
      final ApiResponse apiResponse = await articlesRepo.getBookmarks(params);
      final ArticleModelBody articles = ArticleModelBody.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      _bookmarks.addAll(articles.data!);
      emit(BookmarksSuccess(_bookmarks, isLastPage: articles.meta!.lastPage == articles.meta!.currentPage));
    } catch (e) {
      emit(BookmarksError(e.toString()));
    }
  }

  Future<void> getArticleDetails(String articleId) async {
    emit(ArticleDetailsLoading());
    try {
      final ApiResponse apiResponse = await articlesRepo.getArticleDetails(articleId);
      final ArticleModel article = ArticleModel.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      emit(ArticleDetailsSuccess(article));
    } catch (e) {
      emit(ArticleDetailsError(e.toString()));
    }
  }

  Future<void> bookmarkedArticle({required String articleId, required bool favorite}) async {
    try {
      final ApiResponse apiResponse = await articlesRepo.bookmarkArticle(articleId, favorite);
      final ArticleModel article = ArticleModel.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      emit(ArticleBookmarkSuccess(article));
    } catch (e) {
      emit(ArticleBookmarkError(e.toString()));
    }
  }

  Future<void> lovedArticle({required String articleId, required bool like}) async {
    try {
      final ApiResponse apiResponse = await articlesRepo.lovedArticle(articleId, like);
      final ArticleModel article = ArticleModel.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      emit(ArticleBookmarkSuccess(article));
    } catch (e) {
      emit(ArticleBookmarkError(e.toString()));
    }
  }

  Future<void> searchArticle(String query) async {
    try {
      final ApiResponse apiResponse = await articlesRepo.searchArticle('q=$query');
      final List<ArticleModel> articles =
          List<ArticleModel>.from((apiResponse.response!.data['body'] as List<ArticleModel>).map((ArticleModel x) => x));

      emit(ArticleSearchSuccess(articles));
    } catch (e) {
      emit(ArticleSearchError(e.toString()));
    }
  }

  void onChangedText(String value) {
    if (value.isNotEmpty) {
      searchArticle(value);
    }
  }

  Future<void> addComment({required String articleId, required String comment}) async {
    emit(AddCommentLoading());
    try {
      final ApiResponse apiResponse = await articlesRepo.addComment(articleId, comment);
      final CommentModel commentModel = CommentModel.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      emit(AddCommentSuccess(commentModel));
    } catch (e) {
      emit(AddCommentError(e.toString()));
    }
  }

  Future<void> getArticleComments(String articleId, {int currentPage = 1}) async {
    if (isClosed) {
      return;
    }
    emit(ArticleCommentsLoading(refresh: currentPage == 1, loading: currentPage > 1));
    try {
      if (currentPage == 1) {
        _articleComments.clear();
      }
      final ApiResponse apiResponse = await articlesRepo.getComments(articleId);
      if (isClosed) {
        return;
      }
      final CommentsModelBody comments = CommentsModelBody.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      _articleComments.addAll(comments.data!);
      emit(ArticleCommentsSuccess(_articleComments, isLastPage: comments.meta!.lastPage == comments.meta!.currentPage));
    } catch (e) {
      if (!isClosed) {
        emit(ArticleCommentsError(e.toString()));
      }
    }
  }

  Future<void> deleteComment(String commentId) async {
    emit(DeleteCommentLoading());
    try {
      await articlesRepo.deleteComment(commentId);
      emit(DeleteCommentSuccess(commentId));
    } catch (e) {
      emit(DeleteCommentError(e.toString()));
    }
  }

  Future<void> updateComment({required String commentId, required String comment}) async {
    emit(UpdateCommentLoading());
    try {
      final ApiResponse apiResponse = await articlesRepo.updateComment(commentId, comment);
      final CommentModel articleComment = CommentModel.fromJson(apiResponse.response!.data['body'] as Map<String, dynamic>);
      emit(UpdateCommentSuccess(articleComment));
    } catch (e) {
      emit(UpdateCommentError(e.toString()));
    }
  }

  Future<void> initialUpdateComment(String commentId, String comment) async {
    emit(InitialUpdateComment(commentId, comment));
  }
}
