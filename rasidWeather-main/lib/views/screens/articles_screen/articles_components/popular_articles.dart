import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../data/model/article_home_model.dart';
import '../../../../data/model/article_model.dart';
import '../../../../utils/ui_utils.dart';
import '../../../base/index.dart';
import '../cards/index.dart';

class PopularArticles extends StatefulWidget {
  const PopularArticles({super.key});

  @override
  State<PopularArticles> createState() => _PopularArticlesState();
}

class _PopularArticlesState extends State<PopularArticles> {
  List<ArticleModel>? articles = <ArticleModel>[];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ArticlesBloc, ArticlesState>(
      listener: (BuildContext context, ArticlesState state) {
        if (state is ArticlesHomeError) {
          showSnackBar(context, state.error, color: Colors.red);
        }
        if (state is ArticlesHomeSuccess) {
          articles = state.articlesHome.where((ArticleHomeModel element) => element.type == 'tops').first.list!.data;
        }
      },
      builder: (BuildContext context, ArticlesState state) {
        if (state is ArticlesHomeLoading) {
          return const LoadingCard(height: 200);
        }
        if (articles == null || articles!.isEmpty) {
          return Container();
        }
        return Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              top: 10,
              bottom: 5,
              right: 15,
            ),
            child: Row(children: <Widget>[
              Container(
                height: 23,
                width: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'popular news',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ).tr(),
              const Spacer(),
              TextButton(
                child: Text(
                  'view all',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                  ),
                ).tr(),
                onPressed: () {
                  // nextScreen(context, MoreArticles(title: 'popular news'));
                },
              ),
            ]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 15,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: articles!.isEmpty ? 2 : articles!.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 5,
                    child: Divider(height: 0, thickness: .2, indent: 10, endIndent: 10, color: Color(0xff3D3C3C)),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Card4(article: articles![index], elevation: 0, color: Colors.transparent, padding: 5);
                }),
          ),
        ]);
      },
    );
  }
}
