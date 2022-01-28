import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/login/shop_login_screen.dart';
import 'package:udemy_flutter/modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'package:udemy_flutter/layout/shop_app/shop_layout.dart';
import 'package:udemy_flutter/shared/bloc_observer.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:udemy_flutter/shared/components/cubit/cubit.dart';
import 'package:udemy_flutter/shared/components/cubit/states.dart';
import 'package:udemy_flutter/shared/network/loal/cache_helper.dart';
import 'package:udemy_flutter/shared/network/remote/dio_helper.dart';
import 'package:udemy_flutter/shared/styles/themes.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key:'isDark');

  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  print('token is');
  print(token);


  Widget widget;


  if(onBoarding != null)
    {
      if(token != null) widget = ShopLayout();
      else widget = ShopLoginScreen();
    }else{
    widget = OnBoardingScreen();
  }

  print(onBoarding);


  runApp(MyApp(
      isDark ,
    startWidget: widget,
     ));
}
class MyApp extends StatelessWidget
{

  final bool? isDark;
  final Widget startWidget;

  MyApp(
      this.isDark,
      {required this.startWidget}
      );


  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) =>AppCubit()..changeAppMode(fromShared: isDark,),),
        BlocProvider(create: (context) =>ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData(),),
      ],
      child: BlocConsumer<AppCubit ,AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            themeMode: AppCubit.get(context).isDark ? ThemeMode.light : ThemeMode.dark,

            home : startWidget,
          );
        },

      ),
    );
  }
}