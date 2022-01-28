import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/register/shop_register_screen.dart';
import 'package:udemy_flutter/layout/shop_app/shop_layout.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:udemy_flutter/shared/network/loal/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit,ShopLoginStates>(
        listener: (context , state)
        {
          if (state is ShopLoginSuccessState)
            {
              if(state.loginModel!.status!)
                {
                  print(state.loginModel!.message);
                  print(state.loginModel!.data!.token);
                  CacheHelper.saveData(
                      key: 'token',
                      value: state.loginModel!.data!.token
                  ).then((value)
                  {
                    token=state.loginModel!.data!.token;
                    navigateAndFinish(context, ShopLayout());
                  });

                }
              else
                {
                  print(state.loginModel!.message);
                  showToast(
                      text: state.loginModel!.message,
                  state: ToastStates.ERROR
                  );

                }
            }
        },
        builder: (context, state)
        {
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 20.0,
                    bottom: 20.0,
                    end: 20.0
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Image(image:
                        AssetImage('assets/images/login.png')),
                        Text(
                          'Login',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                              color: Colors.red
                          ),
                        ),
                        Text(
                          'login now to browse our hot offers',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                              color: Colors.black26
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: emailController,

                          type: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email must not be empty';
                            }
                            else {
                              return null;
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),

                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Password is too short';
                              }
                              else {
                                return null;
                              }
                            },
                            onSubmit: (value)
                            {
                              if(formKey.currentState!.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            label: 'Password',
                            prefix: Icons.lock_outline,
                            isPssword: ShopLoginCubit.get(context).isPassword,
                            suffix: ShopLoginCubit.get(context).suffix,
                            suffixPressed: ()
                            {
                              ShopLoginCubit.get(context).ChangePasswordVisibility();
                            }
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildCondition(

                          condition: state is! ShopLoginLoadingState,
                          builder: (context)=> defaultButton(
                            text: 'Login',
                            isUpperCase: true,

                            function: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },

                          ),
                          fallback: (context)=> Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Center(
                          child: Row(

                            children: [
                              Text(
                                  'Don\'t have an account?'
                              ),
                              defaultTextButton(
                                  text: 'REGISTER NOW',
                                  function: () {
                                    navigateTo(context, ShopRegisterScreen());
                                  }
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            );
        },
      ),
    );
  }
}
