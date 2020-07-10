import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:ShopApp/screens/product_overview_screen.dart';
import 'package:ShopApp/provider/products.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Products>.value(value: Products()),
        ChangeNotifierProvider<Cart>.value(value: Cart()),
      ],
      //create: (context) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        },
      ),
    );
  }
}
