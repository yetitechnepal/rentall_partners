import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class Category {
  late int id;
  late String name, description, image;

  Category.fromMap(map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "";
    description = map['description'] ?? "";
    image = map['image'] ?? "";
  }
}

class CategoriesModel {
  List<Category> categories = [];
  Future<CategoriesModel> fetchCategories() async {
    Response response =
        await API().get(endPoint: "equipment/category/", useToken: false);
    if (response.statusCode == 200) {
      categories = [];
      for (int index = 0; index < response.data['data'].length; index++) {
        categories.add(Category.fromMap(response.data['data'][index]));
      }
    }
    return this;
  }
}

class CategoriesCubit extends Cubit<CategoriesModel> {
  CategoriesCubit() : super(CategoriesModel());
  fetchCategories() async {
    CategoriesModel categoriesModel = CategoriesModel();
    await categoriesModel.fetchCategories();
    emit(categoriesModel);
  }
}
