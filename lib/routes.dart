import 'package:flutter/widgets.dart';
//import 'package:piot/modules/cart/cart_screen.dart';
import 'package:piot/modules/complete_profile/complete_profile_screen.dart';
//import 'package:piot/modules/details/details_screen.dart';
//import 'package:piot/modules/forgot_password/forgot_password_screen.dart';
import 'package:piot/modules/home_page.dart';
//import 'package:piot/modules/login_success/login_success_screen.dart';
import 'package:piot/modules/otp/otp_screen.dart';
//import 'package:piot/modules/profile/profile_screen.dart';
import 'package:piot/modules/sign_in/sign_in.dart';
import 'package:piot/modules/splash/splash.dart';
import 'package:piot/modules/sign_up/signup.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  //ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  //LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomePage.routeName: (context) => HomePage(),
  //DetailsScreen.routeName: (context) => DetailsScreen(),
  //CartScreen.routeName: (context) => CartScreen(),
  //ProfileScreen.routeName: (context) => ProfileScreen(),
};
