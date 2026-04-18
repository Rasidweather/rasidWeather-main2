part of 'articles_cubit.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();
}

class ArticlesInitial extends ArticlesState {
  @override
  List<Object> get props => <Object>[];
}

class ArticlesLoading extends ArticlesState {

  const ArticlesLoading({required this.refresh, required this.loading});
  final bool refresh;
  final bool loading;

  @override
  List<Object> get props => <Object>[refresh, loading];
}

class ArticlesSuccess extends ArticlesState {

  const ArticlesSuccess(this.articles, {required this.isLastPage});
  final List<ArticleModel> articles;
  final bool isLastPage;

  @override
  List<Object> get props => <Object>[
        articles,
        isLastPage,
      ];
}

class ArticlesError extends ArticlesState {

  const ArticlesError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class ArticlesHomeLoading extends ArticlesState {
  @override
  List<Object> get props => <Object>[];
}

class ArticlesHomeSuccess extends ArticlesState {

  const ArticlesHomeSuccess(this.articlesHome);
  final List<ArticleHomeModel> articlesHome;

  @override
  List<Object> get props => <Object>[articlesHome];
}

class ArticlesHomeError extends ArticlesState {

  const ArticlesHomeError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class ArticleDetailsLoading extends ArticlesState {
  @override
  List<Object> get props => <Object>[];
}

class ArticleDetailsSuccess extends ArticlesState {

  const ArticleDetailsSuccess(this.articleDetails);
  final ArticleModel articleDetails;

  @override
  List<Object> get props => <Object>[articleDetails];
}

class ArticleDetailsError extends ArticlesState {

  const ArticleDetailsError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class ArticleBookmarkSuccess extends ArticlesState {

  const ArticleBookmarkSuccess(this.article);
  final ArticleModel article;

  @override
  List<Object> get props => <Object>[article];
}

class ArticleBookmarkError extends ArticlesState {

  const ArticleBookmarkError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class ArticleSearchSuccess extends ArticlesState {

  const ArticleSearchSuccess(this.articles);
  final List<ArticleModel> articles;

  @override
  List<Object> get props => <Object>[
        articles,
      ];
}

class ArticleSearchError extends ArticlesState {

  const ArticleSearchError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class BookmarksLoading extends ArticlesState {

  const BookmarksLoading({required this.refresh, required this.loading});
  final bool refresh;
  final bool loading;

  @override
  List<Object> get props => <Object>[
        refresh,
        loading,
      ];
}

class BookmarksSuccess extends ArticlesState {

  const BookmarksSuccess(this.articles, {required this.isLastPage});
  final List<ArticleModel> articles;
  final bool isLastPage;

  @override
  List<Object> get props => <Object>[
        articles,
        isLastPage,
      ];
}

class BookmarksError extends ArticlesState {

  const BookmarksError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class AddCommentLoading extends ArticlesState {
  @override
  List<Object> get props => <Object>[];
}

class AddCommentSuccess extends ArticlesState {

  const AddCommentSuccess(this.comment);
  final CommentModel comment;

  @override
  List<Object> get props => <Object>[
        comment,
      ];
}

class AddCommentError extends ArticlesState {

  const AddCommentError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class ArticleCommentsLoading extends ArticlesState {

  const ArticleCommentsLoading({required this.refresh, required this.loading});
  final bool refresh;
  final bool loading;

  @override
  List<Object> get props => <Object>[
        refresh,
        loading,
      ];
}

class ArticleCommentsSuccess extends ArticlesState {

  const ArticleCommentsSuccess(this.comments, {required this.isLastPage});
  final List<CommentModel> comments;
  final bool isLastPage;

  @override
  List<Object> get props => <Object>[
        comments,
        isLastPage,
      ];
}

class ArticleCommentsError extends ArticlesState {

  const ArticleCommentsError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class DeleteCommentLoading extends ArticlesState {
  @override
  List<Object> get props => <Object>[];
}

class DeleteCommentSuccess extends ArticlesState {

  const DeleteCommentSuccess(this.commentId);
  final String commentId;

  @override
  List<Object> get props => <Object>[
        commentId,
      ];
}

class DeleteCommentError extends ArticlesState {

  const DeleteCommentError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class UpdateCommentLoading extends ArticlesState {
  @override
  List<Object> get props => <Object>[];
}

class UpdateCommentSuccess extends ArticlesState {

  const UpdateCommentSuccess(this.comment);
  final CommentModel comment;

  @override
  List<Object> get props => <Object>[
        comment,
      ];
}

class UpdateCommentError extends ArticlesState {

  const UpdateCommentError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class InitialUpdateComment extends ArticlesState {

  const InitialUpdateComment(this.commentId, this.comment);
  final String commentId;
  final String comment;

  @override
  List<Object> get props => <Object>[
        commentId,
        comment,
      ];
}
