import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/model/base/api_response.dart';
import '../../data/model/category_model.dart';
import '../../data/repository/articles_repo.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this.articlesRepo) : super(CategoriesInitial());

  final ArticlesRepo articlesRepo;

  Future<void> getCategories() async {
    emit(CategoriesLoading());
    try {
      final ApiResponse apiResponse = await articlesRepo.getCategories();
      final List<CategoryModel> categories =
          List<CategoryModel>.from((apiResponse.response!.data['body'] as Iterable).map((x) => CategoryModel.fromJson(x as Map<String, dynamic>)));
      emit(CategoriesSuccess(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }

  void categorySelected({required CategoryModel category}) {
    emit(SelectedCategory(category));
  }
}
