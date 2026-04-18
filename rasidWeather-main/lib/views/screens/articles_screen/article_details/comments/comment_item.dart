import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../../common/constants/images.dart';
import '../../../../../data/model/comment_model.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required this.comment});

  final CommentModel comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(widget.comment.user?.avatar!.original ?? Images.defaultAvatar)),
      title: Text(widget.comment.user!.name!),
      subtitle: Text(widget.comment.content!),
      trailing: FutureBuilder<bool>(
          future: context.read<ProfileCubit>().isCurrentUser(widget.comment.user!.id!),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            print('snapshot.data ${snapshot.data}');
            if (snapshot.hasData && snapshot.data!) {
              return SizedBox(
                height: 30,
                width: 30,
                child: moreButton(widget.comment),
              );
            } else {
              return const SizedBox(width: 0);
            }
          }),
    );
  }

  Widget moreButton(CommentModel comment) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
           PopupMenuItem<String>(
            value: 'delete',
            child: Text('articles.comments.delete'.tr()),
          ),
           PopupMenuItem<String>(
            value: 'edit',
            child: Text('articles.comments.edit'.tr()),
          ),
        ];
      },
      onSelected: (String value) {
        if (value == 'delete') {
          context.read<ArticlesBloc>().deleteComment(comment.id!);
        }
        if (value == 'edit') {
          context.read<ArticlesBloc>().initialUpdateComment(comment.id!, comment.content!);
        }
      },
    );
  }
}
