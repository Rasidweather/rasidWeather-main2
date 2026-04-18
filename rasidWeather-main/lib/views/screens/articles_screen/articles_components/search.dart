import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../common/widgets/header_widget.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../data/model/article_model.dart';
import '../../../base/empty_widget.dart';
import '../cards/index.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[200],
        leading: const AdaptiveBackButton(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: HeaderWidget(title: 'search news'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
          SizedBox(height: 20.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: TextField(
              onChanged: context.read<ArticlesBloc>().onChangedText,
              autofocus: true,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                filled: true,
                hintText: 'ابحث',
                fillColor: Colors.grey[300],
                prefixIcon: const SizedBox(width: 5),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: BlocConsumer<ArticlesBloc, ArticlesState>(
              listener: (BuildContext context, ArticlesState state) {},
              builder: (BuildContext context, ArticlesState state) {
                if (state is ArticlesInitial) {
                  return Center(
                    child: EmptyWidget(
                      icon: FeatherIcons.search,
                      message: 'search news'.tr(),
                      message1: 'search-description'.tr(),
                    ),
                  );
                }
                if (state is ArticleSearchSuccess) {
                  return ListView.builder(
                      itemCount: state.articles.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ArticleModel city = state.articles[index];
                        return Card4(article: city);
                      });
                }
                if (state is ArticleSearchError) {
                  return Center(child: Text(state.error));
                }
                return Container();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
