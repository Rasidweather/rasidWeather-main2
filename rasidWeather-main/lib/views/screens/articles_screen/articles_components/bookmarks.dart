import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../locator.dart';
import '../../../base/index.dart';
import '../cards/index.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  BookmarkScreenState createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticlesBloc>(
      create: (BuildContext context) => sl<ArticlesBloc>()..getBookmarks(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'articles.bookmarks.title'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: AdaptiveBackButton(
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(builder: (BuildContext context, ProfileState state) {
            if (state is ProfileLoading) {
              return Container();
            }
            if (state is ProfileSuccess) {
              return const BookmarkedArticles();
            }
            return EmptyWidget(
              icon: FeatherIcons.userPlus,
              message: 'sign in first'.tr(),
              message1: 'sign in to save your favourite articles here'.tr(),
            );
          }),
        ),
      ),
    );
  }
}

class BookmarkedArticles extends StatefulWidget {
  const BookmarkedArticles({super.key});

  @override
  BookmarkedArticlesState createState() => BookmarkedArticlesState();
}

class BookmarkedArticlesState extends State<BookmarkedArticles> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (BuildContext context, ArticlesState state) {
        if (state is BookmarksLoading) {
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: 8,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 5),
            itemBuilder: (BuildContext context, int index) {
              return const LoadingCard(height: 160);
            },
          );
        }
        if (state is BookmarksError) {
          return EmptyWidget(
            icon: FeatherIcons.bookmark,
            message: 'error'.tr(),
            message1: state.error,
          );
        }
        if (state is BookmarksSuccess) {
          return state.articles.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.all(15),
                  itemCount: state.articles.length,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 5),
                  itemBuilder: (BuildContext context, int index) {
                    return Card4(article: state.articles[index]);
                  },
                )
              : EmptyWidget(
                  icon: FeatherIcons.bookmark,
                  message: 'no articles found'.tr(),
                  message1: 'save your favourite articles here'.tr(),
                );
        }
        return Container();
      },
    );
  }
}
