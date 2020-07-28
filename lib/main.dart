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
import 'package:ShopApp/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          // create: (context) => Products(context.read<Auth>().token, []),
          // update: (context, Auth auth, Products previousProducts) =>
          //     Products(auth.token, previousProducts.items),
          create: (context) => Products(),
          update: (context, Auth auth, previous) =>
              previous..update(auth.token, auth.userId, previous.items),
        ),
        ChangeNotifierProvider<Cart>.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, Auth auth, previous) =>
              previous..update(auth.token, previous.orders, auth.userId),
        )
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
            // first check if it's logined
            '/': (context) => authData.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    //if not, try auto login
                    future: authData.tryAutoLogin(),
                    builder: (context, authSnapshot) =>
                        authSnapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
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
