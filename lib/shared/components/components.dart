import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:udemy_flutter/modules/shop_app/cubit/cubit.dart';
import 'package:udemy_flutter/shared/styles/colors.dart';

Widget defaultButton (
{
  double width = double.infinity,
  Color background = defaultColor,
  required VoidCallback function,
  required String text,
  bool isUpperCase = true,
  double borderRadius =10.0,
}) => Container(
  width: width,
  height: 45.0,
  child: MaterialButton(
    onPressed: function ,
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(borderRadius,),
  ),
);

Widget defaultTextButton ({
  required String text,
  required VoidCallback? function,
}) =>TextButton(
    onPressed: function ,
    child: Text(text.toUpperCase()),
  );


Widget defaultFormField ({
  required TextEditingController controller,
  required TextInputType type,
  bool isPssword = false,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isClickable = true,
  required  FormFieldValidator<String>? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,


}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPssword,
  onFieldSubmitted: onSubmit ,

  onChanged: onChange ,
  onTap: onTap,
  enabled: isClickable,
  validator: validate,
  decoration: InputDecoration(
    labelText: label ,
    prefixIcon:Icon(
      prefix,
    ),
    suffixIcon: IconButton(
      onPressed :suffixPressed,
      icon: Icon(
        suffix
      ),
    ),
  ),
);





Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    height: 1.0,
    color: Colors.grey[300],
    width: double.infinity,
  ),
);


void navigateTo(context , widget) => Navigator.push(context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
);

void showToast({required String text , required ToastStates state}) => Fluttertoast.showToast(
    msg: text ,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

//enum
enum ToastStates {SUCCESS , ERROR , WARNING}

Color? chooseToastColor(ToastStates state)
{
  Color color;
  switch(state)
  {

    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
  }
  return color;
}


Widget buildListProducts( model ,context , {bool isOldPrice = true ,}


) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120.0,


    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage(model.image!),
              width: 120.0,
              height: 120.0,

            ),
            if(model.discount != 0 && isOldPrice)
              Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: Text(
                    'DISCOUNT',
                    style: TextStyle(
                        fontSize: 8.0,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 1.4,

                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: defaultColor,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  if(model.discount != 0 && isOldPrice)
                    Text(
                      model.oldPrice.toString(),
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,

                      ),
                    ),
                  Spacer(),
                  IconButton(
                    onPressed: ()
                    {
                      ShopCubit.get(context).changeFavorites(model.id!);

                    },
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: ShopCubit.get(context).favorites[model.id]! ? defaultColor : Colors.grey,
                      child: Icon(Icons.favorite_border,
                        size: 14.0,
                        color: Colors.white,

                      ),
                    ),

                  ),

                ],
              ),
            ],
          ),
        ),

      ],
    ),
  ),
);

