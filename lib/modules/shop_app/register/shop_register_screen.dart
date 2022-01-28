import 'package:flutter/material.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/login/cubit/states.dart';
import 'package:udemy_flutter/modules/shop_app/register/cubit/cubit.dart';
import 'package:udemy_flutter/modules/shop_app/register/shop_register_screen.dart';
import 'package:udemy_flutter/layout/shop_app/shop_layout.dart';
import 'package:udemy_flutter/shared/components/components.dart';
import 'package:udemy_flutter/shared/components/constants.dart';
import 'package:udemy_flutter/shared/network/loal/cache_helper.dart';
import 'package:udemy_flutter/shared/styles/colors.dart';

import 'cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget
{
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (context)=>ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>
        (
        listener: (context,state)
        {
          if (state is ShopRegisterSuccessState)
          {
            if(state.loginModel!.status!)
            {
              print(state.loginModel!.message);
              print(state.loginModel!.data!.token);
              CacheHelper.saveData(
                  key: 'token',
                  value: (state.loginModel!.data!.token)
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
        builder: (context,state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Text(
                        'Register',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline3!
                            .copyWith(
                            color: Colors.red
                        ),
                      ),
                      Text(
                        'Register now to browse our hot offers',
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
                        controller: nameController,

                        type: TextInputType.name,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Name must not be empty';
                          }
                          else {
                            return null;
                          }
                        },
                        label: 'Name',
                        prefix: Icons.person,
                      ),
                      SizedBox(
                        height: 15.0,
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
                        controller: phoneController,

                        type: TextInputType.phone,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return 'Phone must not be empty';
                          }
                          else {
                            return null;
                          }
                        },
                        label: 'Phone number',
                        prefix: Icons.phone,
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

                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          isPssword: ShopRegisterCubit.get(context).isPassword,
                          suffix: ShopRegisterCubit.get(context).suffix,
                          suffixPressed: ()
                          {
                            ShopRegisterCubit.get(context).ChangeRegisterPasswordVisibility();
                          }
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      BuildCondition(

                        condition: state is! ShopRegisterLoadingState,
                        builder: (context)=> defaultButton(
                          text: 'Register',
                          isUpperCase: true,

                          function: ()
                          {
                            if(formKey.currentState!.validate())
                            {
                              ShopRegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                password: passwordController.text,
                              );
                            }
                          },

                        ),
                        fallback: (context)=> Center(child: CircularProgressIndicator(color: defaultColor,)),
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
