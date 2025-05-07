import 'package:flutter/material.dart';
import 'package:speffo/Helper/page_router.dart';
import 'package:speffo/Login/View/login_main_view.dart';

signOutCallAction({required BuildContext context}){
 PageRouter.pushRemoveUntil(context, LoginMainView()) ;
}