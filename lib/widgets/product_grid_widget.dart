import 'package:flutter/material.dart';
import 'package:ShopApp/widgets/product_item_widget.dart';
import 'package:ShopApp/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductGridWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<ProductProvider>();
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) => ProductItemWidget(
        id: products[index].id,
        imageUrl: products[index].imageUrl,
        title: products[index].title,
      ),
    );
  }
}
