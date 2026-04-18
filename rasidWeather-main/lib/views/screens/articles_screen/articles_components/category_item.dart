import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/categories_cubit/categories_cubit.dart';
import '../../../../data/model/category_model.dart';

class CategoryItem extends StatelessWidget {

  const CategoryItem({super.key, required this.tag, required this.category});
  final String tag;

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (BuildContext context, CategoriesState state) {
        if (state is SelectedCategory && state.category.id == category.id) {
          return _item(context, selected: true);
        }
        return _item(context);
      },
    );
  }

  InkWell _item(BuildContext context, {bool? selected = false}) {
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: selected! ? Colors.cyan : const Color(0xffE6EAEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: tag,
                child: Center(
                  child: Text(
                    category.title!,
                    style: TextStyle(
                      fontSize: 12,
                      color: selected ? Colors.white : const Color(0xff3D3C3C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onTap: () {
          context.read<CategoriesCubit>().categorySelected(category: category);
        });
  }
}
