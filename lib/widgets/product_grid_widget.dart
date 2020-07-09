import 'package:flutter/material.dart';
import 'package:ShopApp/widgets/product_item_widget.dart';
import 'package:ShopApp/provider/products.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/product.dart';

class ProductGridWidget extends StatelessWidget {
  final bool showFavorites;

  ProductGridWidget(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<Products>();
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider<Product>.value(
        value: products[index],
        child: ProductItemWidget(
            // id: products[index].id,
            // imageUrl: products[index].imageUrl,
            // title: products[index].title,
            ),
      ),
    );
  }
}
