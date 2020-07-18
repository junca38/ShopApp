import 'package:ShopApp/provider/auth.dart';
import 'package:ShopApp/screens/cart_screen.dart';
import 'package:ShopApp/screens/edit_product_screen.dart';
import 'package:ShopApp/screens/order_screen.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:ShopApp/screens/user_product_screen.dart';

import 'package:flutter/material.dart';
import 'package:ShopApp/screens/product_overview_screen.dart';
import 'package:ShopApp/provider/products.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/cart.dart';
import 'package:ShopApp/provider/orders.dart';

import 'package:ShopApp/screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>.value(value: Products()),
        ChangeNotifierProvider<Cart>.value(value: Cart()),
        ChangeNotifierProvider<Orders>.value(value: Orders()),
        ChangeNotifierProvider<Auth>.value(value: Auth()),
      ],
      //create: (context) => Products(),
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          initialRoute: '/',
          routes: {
            '/': (context) =>
                authData.isAuth ? ProductOverviewScreen() : AuthScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
            ProductOverviewScreen.routeName: (context) =>
                ProductOverviewScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
