part of 'categories_cubit.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {
  @override
  List<Object> get props => <Object>[];
}

class CategoriesLoading extends CategoriesState {
  @override
  List<Object> get props => <Object>[];
}

class CategoriesSuccess extends CategoriesState {

  const CategoriesSuccess(this.categories);
  final List<CategoryModel> categories;

  @override
  List<Object> get props => <Object>[categories];
}

class CategoriesError extends CategoriesState {

  const CategoriesError(this.error);
  final String error;

  @override
  List<Object> get props => <Object>[error];
}

class SelectedCategory extends CategoriesState {

  const SelectedCategory(this.category);
  final CategoryModel category;

  @override
  List<Object> get props => <Object>[category];
}
