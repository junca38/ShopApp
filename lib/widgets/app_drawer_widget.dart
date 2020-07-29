import 'package:ShopApp/screens/order_screen.dart';
import 'package:ShopApp/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/auth.dart';
import 'package:ShopApp/helpers/custom_route.dart';

class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Halo'),
              automaticallyImplyLeading: false,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text('Shop'),
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () => Navigator.of(context)
                  //.pushReplacementNamed(OrderScreen.routeName),
                  .pushReplacement(
                      CustomRoute(builder: (context) => OrderScreen())),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('ManageProduct'),
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                context.read<Auth>().logout();
              },
            )
          ],
        ),
      ),
    );
  }
}
