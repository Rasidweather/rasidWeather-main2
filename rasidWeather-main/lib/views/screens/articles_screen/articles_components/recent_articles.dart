import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../data/model/article_home_model.dart';
import '../../../../data/model/article_model.dart';
import '../../../../utils/ui_utils.dart';
import '../../../base/index.dart';
import '../cards/index.dart';

// TODO(mohamedSleem): not used.
class RecentArticles extends StatefulWidget {
  const RecentArticles({super.key});

  @override
  RecentArticlesState createState() => RecentArticlesState();
}

class RecentArticlesState extends State<RecentArticles> {
  List<ArticleModel> articles = <ArticleModel>[];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticlesBloc, ArticlesState>(
      listener: (BuildContext context, ArticlesState state) {
        if (state is ArticlesHomeError) {
          showSnackBar(context, state.error, color: Colors.red);
        }
        if (state is ArticlesHomeSuccess) {
          articles = state.articlesHome.where((ArticleHomeModel element) => element.type == 'latests').first.list!.data!;
        }
      },
      builder: (BuildContext context, ArticlesState state) {
        if (state is ArticlesHomeLoading || state is ArticlesInitial) {
          return const LoadingCard(height: 200);
        }
        return _item();
      },
    );
  }

  Column _item() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
            top: 15,
            bottom: 10,
            right: 15,
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 22,
                width: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'recent news',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(),
            ],
          ),
        ),
        ListView.separated(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: articles.isNotEmpty ? articles.length + 1 : 1,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 15,
          ),
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            if (index < articles.length) {
              if (index % 3 == 0 && index != 0) {
                return Card5(article: articles[index], heroTag: articles[index].id!);
              }
              if (index % 5 == 0 && index != 0) {
                return Card4(article: articles[index]);
              } else {
                return Card2(article: articles[index], heroTag: articles[index].id!);
              }
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}
