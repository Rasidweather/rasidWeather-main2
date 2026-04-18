import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../bloc/categories_cubit/categories_cubit.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/category_model.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/ui_utils.dart';
import '../../../base/index.dart';
import 'new_view.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<CategoryModel> categories = <CategoryModel>[];

  @override
  void initState() {
    context.read<CategoriesCubit>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (BuildContext context, CategoriesState state) {
        if (state is SelectedCategory) {
          context.read<ArticlesBloc>().getArticles(categories: state.category.id);
        }
        if (state is CategoriesSuccess) {
          categories = state.categories;
        }
        if (state is CategoriesError) {
          showSnackBar(context, state.error, color: Colors.red);
        }
      },
      builder: (BuildContext context, CategoriesState state) {
        if (state is CategoriesLoading) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 120),
                ListView.separated(
                  key: const PageStorageKey<String>('image'),
                  padding: const EdgeInsets.all(15),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    if (index == 0) {
                      return const LoadingCard(height: 200);
                    }
                    if (index == 1) {
                      return const LoadingCard(height: 160);
                    }
                    return const LoadingCard(height: 140);
                  },
                ),
              ],
            ),
          );
        }
        if (state is CategoriesError) {
          return Text(state.error);
        }
        return Articles(categories: categories);
      },
    );
  }
}

class Articles extends StatefulWidget {
  const Articles({super.key, required this.categories});

  final List<CategoryModel> categories;

  @override
  ArticlesState createState() => ArticlesState();
}

class ArticlesState extends State<Articles> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 10,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('articles.title'.tr(), style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .08,
                      child: const Divider(height: 0, thickness: 1.4, color: Color(0xff3D3C3C)),
                    ),
                  ],
                ),
              ),
              elevation: 1,
              actions: <Widget>[
                IconButton(
                  icon: ImageView.svgAsset(Assets.svgBookmarkBoard),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => RouterHelper.getBookmarkRoute(),
                ),
              ],
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                isScrollable: true,
                tabs:
                    widget.categories.map((CategoryModel e) {
                      return GestureDetector(child: Tab(text: e.title));
                    }).toList(),
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return TabBarView(
              controller: _tabController,
              children: <Widget>[
                ...List<Widget>.generate(widget.categories.length, (int index) {
                  return ContentNewsTab(selectedCategory: widget.categories[index]);
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}
