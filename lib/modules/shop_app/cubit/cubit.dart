import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/models/shop_app/categories_model.dart';
import 'package:udemy_flutter/models/shop_app/change_favorites_model.dart';
import 'package:udemy_flutter/models/shop_app/favorites_model.dart';
import 'package:udemy_flutter/models/shop_app/home_model.dart';
import 'package:udemy_flutter/models/shop_app/shop_model.dart';
import 'package:udemy_flutter/modules/shop_app/categories/cateogries_screen.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/favorites/favorites_screen.dart';
import 'package:udemy_flutter/modules/shop_app/products/products_screen.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:udemy_flutter/shared/network/end_points.dart';
import 'package:udemy_flutter/shared/network/loal/cache_helper.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens =
      [
        ProductsScreen(),
        CategoriesScreen(),
        FavoritesScreen(),
      ];

  void changeBottom(int index)
  {
    currentIndex = index ;

    emit(ShopChangeBottomNavState());
  }


  HomeModel? homeModel;


  Map<int , bool> favorites = {};


  void getHomeData ()
  {
    emit(ShopLoadingHomeState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value)
    {
      homeModel = HomeModel.fromJson(value.data);

      //printFullText(homeModel!.data!.banners![0].image);

      //print(homeModel!.status);

      homeModel!.data!.products!.forEach((element)
      {
        favorites.addAll
          ({
          element.id! : element.in_favorites!,
        });
      });

      print(favorites.toString());

      emit(ShopSuccessHomeState());

    }).catchError((error)
    {
      print(error.toString());

      emit(ShopErrorHomeState(error.toString()));
    });

  }


  CategoriesModel? categoriesModel;
  void getCategories ()
  {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value)
    {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());

    }).catchError((error)
    {
      print(error.toString());

      emit(ShopErrorCategoriesState(error.toString()));
    });

  }


  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites (int productId)
  {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());


    DioHelper.postData(
        url: FAVORITES,
        data:
      {
        'product_id':productId,
      },
      token: token,
    ).then((value)
    {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);

      if(!changeFavoritesModel!.status!)
        {
          favorites[productId] = !favorites[productId]!;
        }else
          {
            getFavorites();
          }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));

    }).catchError((error)
    {
      favorites[productId] = !favorites[productId]!;

      emit(ShopErrorChangeFavoritesState(error.toString()));
      print(error.toString());

    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites ()
  {
    emit(ShopSuccessLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value)
    {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesState());

    }).catchError((error)
    {
      print(error.toString());

      emit(ShopErrorGetFavoritesState(error.toString()));



    });

  }

  ShopLoginModel? loginModel;

  void getUserData ()
  {
    emit(ShopSuccessLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: CacheHelper.getData(key: 'token'),
    ).then((value)
    {
      loginModel = ShopLoginModel.fromJason(value.data);
      emit(ShopSuccessUserDataState());
      print(loginModel!.data!.email);
    }).catchError((error)
    {
      print(error.toString());
      emit(ShopErrorUserDataState());


    });

  }

  void updateUserData ({
  required String? name,
    required String? email,
    required String? phone,
})
  {
    emit(ShopSuccessLoadingUpdateUserDataState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: CacheHelper.getData(key: 'token'),
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value)
    {
      loginModel = ShopLoginModel.fromJason(value.data);
      emit(ShopSuccessUpdateUserDataState());
      print(loginModel!.data!.email);


    }).catchError((error)
    {
      print(error.toString());

      emit(ShopErrorUpdateUserDataState());



    });

  }



}