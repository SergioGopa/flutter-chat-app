import 'package:chat/pages/pages.dart';
import 'package:flutter/material.dart';

final Map<String,Widget Function(BuildContext)> appRoutes = {
  'users':( _ )=> UsersPage(),
  'chat':( _ )=> ChatPage(),
  'login':( _ )=> LoginPage(),
  'register':( _ )=> RegisterPage(),
  'loading':( _ )=> LoadingPage(),
  
};
