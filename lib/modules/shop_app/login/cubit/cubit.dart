import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/models/shop_app/shop_model.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/states.dart';
import 'package:udemy_flutter/shared/network/end_points.dart';
import 'package:udemy_flutter/shared/network/loal/cache_helper.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates>
{
  ShopLoginCubit() : super(ShopLoginInitialState());
  static ShopLoginCubit get(context) =>BlocProvider.of(context);

  ShopLoginModel? loginModel;

  void userLogin ({
    required String email,
    required String password,
})
  {
    emit(ShopLoginLoadingState());

    DioHelper.postData(
        url: LOGIN,
        data:
        {
          'email': email,
          'password': password,
        },).then((value)
    {
      print(value.data);
      loginModel = ShopLoginModel.fromJason(value.data);


      emit(ShopLoginSuccessState(loginModel));
      print(CacheHelper.getData(key: 'token'));
    }).catchError((error){
      print(error.toString());
      emit(ShopLoginErrorState(error.toString()));
    });

  }

  IconData suffix = Icons.visibility_outlined;

  bool isPassword= true;

  void ChangePasswordVisibility()
  {
    isPassword = !isPassword;

    suffix = isPassword ?  Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ShopChangePasswordVisibilityState());
  }



}