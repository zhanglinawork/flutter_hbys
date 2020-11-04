
import 'package:flutter/material.dart';

///观测路由，可以对路由的push和pop进行观测
///具体可以查看 类：RouteAwareWidget
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

///root widget的 key，暂时没什么用
/// 不过你可以用它进行无context跳转，eg：
/// navigatorKey.currentState.pop()
/// navigatorKey.currentState.pushNamed('update_page');
/// 不过我不太喜欢这样用(该框架内也并没有这样使用)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();