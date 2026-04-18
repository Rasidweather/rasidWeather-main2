import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../../data/model/article_model.dart';

class AddCommentWidget extends StatefulWidget {
  const AddCommentWidget({
    super.key,
    required this.article,
    required this.openSignInDialog,
    required this.viewPremiumDialog,
  });
  final ArticleModel article;
  final VoidCallback openSignInDialog;
  final VoidCallback viewPremiumDialog;

  @override
  State<AddCommentWidget> createState() => _AddCommentWidgetState();
}

class _AddCommentWidgetState extends State<AddCommentWidget> {
  final TextEditingController commentController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        return FutureBuilder<bool>(
            future: context.read<ProfileCubit>().isLoggedIn(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return _buildCommentInputSection(snapshot.data ?? false);
            });
      },
    );
  }

  Widget _buildCommentInputSection(bool isLoggedIn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: commentController,
              enabled: isLoggedIn && !_isLoading,
              decoration: InputDecoration(
                hintText: isLoggedIn ? 'أضف تعليقك' : 'سجل دخول لإضافة تعليق',
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                errorText: _error,
              ),
              maxLines: 4,
              minLines: 1,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(width: 12),
          _buildSendButton(isLoggedIn),
        ],
      ),
    );
  }

  Widget _buildSendButton(bool isLoggedIn) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.5),
        gradient: LinearGradient(
          colors: <Color>[
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22.5),
          onTap: _isLoading ? null : () => _handleCommentAdd(isLoggedIn),
          child: _isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : const Icon(Icons.send, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  void _handleCommentAdd(bool isLoggedIn) {
    if (!isLoggedIn) {
      widget.openSignInDialog();
      return;
    }
    final String comment = commentController.text.trim();
    if (comment.isEmpty) {
      setState(() {
        _error = 'يرجى إدخال تعليق';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Call the real addComment function
      final ArticlesBloc articlesBloc = BlocProvider.of<ArticlesBloc>(context);
      articlesBloc.addComment(
        articleId: widget.article.id!,
        comment: comment,
      );

      // Clear the text field and show success message
      setState(() {
        _isLoading = false;
        commentController.clear();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إضافة التعليق بنجاح'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh comments list
      articlesBloc.getArticleComments(widget.article.id!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'فشل إضافة التعليق: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error ?? 'حدث خطأ ما'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
