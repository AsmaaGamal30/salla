import 'package:udemy_flutter/models/shop_app/change_favorites_model.dart';
import 'package:udemy_flutter/models/shop_app/shop_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingHomeState extends ShopStates {}

class ShopSuccessHomeState extends ShopStates {}

class ShopErrorHomeState extends ShopStates
{
  final String error;

  ShopErrorHomeState(this.error);
}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates
{
  final String error;

  ShopErrorCategoriesState(this.error);


}

class ShopSuccessChangeFavoritesState extends ShopStates
{
   final ChangeFavoritesModel model ;

  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates
{
  final String error;

  ShopErrorChangeFavoritesState(this.error);

}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessLoadingGetFavoritesState extends ShopStates {}

class ShopSuccessGetFavoritesState extends ShopStates {}

class ShopErrorGetFavoritesState extends ShopStates
{
  final String error;

  ShopErrorGetFavoritesState(this.error);


}

class ShopSuccessLoadingUserDataState extends ShopStates {}

class ShopSuccessUserDataState extends ShopStates {}

class ShopErrorUserDataState extends ShopStates {}

class ShopSuccessLoadingUpdateUserDataState extends ShopStates {}

class ShopSuccessUpdateUserDataState extends ShopStates {}

class ShopErrorUpdateUserDataState extends ShopStates {}





