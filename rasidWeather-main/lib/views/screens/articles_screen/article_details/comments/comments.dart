import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../../core/widgets/back_button.dart';
import '../../../../../data/model/comment_model.dart';
import '../../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../../utils/ui_utils.dart';
import '../../../../base/index.dart';
import 'comment_item.dart';

class ArticleComments extends StatefulWidget {
  const ArticleComments({super.key, required this.articleId});

  final String articleId;

  @override
  State<ArticleComments> createState() => _ArticleCommentsState();
}

class _ArticleCommentsState extends State<ArticleComments> {
  bool isLastPage = false;
  int currentPage = 1;
  List<CommentModel> comments = <CommentModel>[];
  TextEditingController commentController = TextEditingController();

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await context.read<ArticlesBloc>().getArticleComments(widget.articleId);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'articles.comments.title'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading:const AdaptiveBackButton(),
      ),
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _addCommentWidget(),
      body: BlocConsumer<ArticlesBloc, ArticlesState>(
        listener: (BuildContext context, ArticlesState state) {
          if (state is UpdateCommentSuccess) {
            comments.removeWhere((CommentModel element) => element.id == state.comment.id);
            comments.insert(0, state.comment);
          }
          if (state is AddCommentSuccess) {
            comments.insert(0, state.comment);
          }
          if (state is DeleteCommentSuccess) {
            comments.removeWhere((CommentModel element) => element.id == state.commentId);
          }
          if (state is AddCommentError) {
            showSnackBar(context, state.error, color: Colors.red);
          }
          if (state is ArticleCommentsSuccess) {
            comments = state.comments;
            isLastPage = state.isLastPage;
          }
        },
        builder: (BuildContext context, ArticlesState state) {
          if (state is ArticleCommentsLoading) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
          } else if (state is ArticleCommentsError) {
            return Center(
              child: Text(state.error),
            );
          }
          if (comments.isNotEmpty) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              onLoading: _loadMore,
              onRefresh: getData,
              header: const WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = const Icon(Icons.refresh);
                  } else if (mode == LoadStatus.loading) {
                    body = const CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text('articles.comments.load_more_error'.tr());
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text('articles.comments.loading_more'.tr());
                  } else {
                    body = Text('articles.comments.no_more'.tr());
                  }
                  return SizedBox(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: comments.length,
                itemBuilder: (BuildContext context, int index) {
                  return CommentItem(comment: comments[index]);
                },
              ),
            );
          } else {
            return const EmptyWidget(
              icon: Icons.comments_disabled_outlined,
              message: 'لم يتم العثور على\n تعليقات',
              message1: '',
            );
          }
        },
      ),
    );
  }

  Widget _addCommentWidget() {
    return ColoredBox(
      color: Colors.white,
      child: FutureBuilder<bool>(
          future: context.read<AuthCubit>().checkAuthenticationStatus(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            final bool isLoggedIn = snapshot.data!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              child: Row(children: <Widget>[
                Expanded(
                  child: InputField(
                    onTap: () async {
                      final bool guestUser = await context.read<AuthCubit>().checkAuthenticationStatus();
                      if (!guestUser) {
                        await openSignInDialog();
                      } else {
                        return null;
                      }
                    },
                    controller: commentController,
                    isEnabled: isLoggedIn,
                    hintText: 'أضف تعليقك',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'لا يمكنك إضافة تعليق فارغ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xff3d3d3d)),
                  child: BlocConsumer<ArticlesBloc, ArticlesState>(listener: (BuildContext context, ArticlesState state) async {
                    if (state is UpdateCommentSuccess) {
                      commentController.clear();
                    }
                    if (state is InitialUpdateComment) {
                      commentController.text = state.comment;
                    }
                    if (state is AddCommentSuccess) {
                      commentController.clear();
                      await context.read<ArticlesBloc>().getArticleComments(widget.articleId);
                    }
                    if (state is AddCommentError) {
                      if (!context.mounted) {
                        return;
                      }
                      showSnackBar(context, state.error, color: Colors.red);
                    }
                    if (state is UpdateCommentError) {
                      if (!context.mounted) {
                        return;
                      }
                      showSnackBar(context, state.error, color: Colors.red);
                    }
                  }, builder: (BuildContext context, ArticlesState state) {
                    if (state is InitialUpdateComment) {
                      return GestureDetector(
                        onTap: () {
                          if (!isLoggedIn) {
                            openSignInDialog();
                          } else {
                            if (commentController.text.isEmpty) {
                              showSnackBar(context, 'لا يمكنك إضافة تعليق فارغ', color: Colors.red);
                            } else {
                              context.read<ArticlesBloc>().updateComment(commentId: state.commentId, comment: commentController.text);
                            }
                          }
                        },
                        child: const Icon(Icons.check, color: Colors.white),
                      );
                    }
                    if (state is AddCommentLoading || state is UpdateCommentLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        if (!isLoggedIn) {
                          openSignInDialog();
                        } else {
                          if (commentController.text.isEmpty) {
                            showSnackBar(context, 'لا يمكنك إضافة تعليق فارغ', color: Colors.red);
                          } else {
                            context.read<ArticlesBloc>().addComment(articleId: widget.articleId, comment: commentController.text);
                          }
                        }
                      },
                      child: const Icon(Icons.send, color: Colors.white),
                    );
                  }),
                ),
              ]),
            );
          }),
    );
  }

  Future<bool> _loadMore() async {
    if (isLastPage) {
      _refreshController.loadNoData();
      return false;
    }
    if (!mounted) return false;
    await context.read<ArticlesBloc>().getArticleComments(widget.articleId, currentPage: currentPage + 1);
    if (!mounted) return false;
    _refreshController.loadComplete();
    currentPage += 1;
    return true;
  }
}
