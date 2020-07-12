import 'package:ShopApp/screens/edit_product_screen.dart';
import 'package:ShopApp/widgets/app_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/products.dart';
import 'package:ShopApp/widgets/user_product_item_widget.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<Products>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, index) => Column(
            children: <Widget>[
              UserProductItemWidget(
                title: productsData.items[index].title,
                imageUrl: productsData.items[index].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
