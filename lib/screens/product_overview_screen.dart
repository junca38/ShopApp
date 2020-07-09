import 'package:flutter/material.dart';
import 'package:ShopApp/widgets/product_grid_widget.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/products.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Products productsContainer =
        Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                productsContainer.showFavoritesOnly();
              } else {
                productsContainer.showAll();
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
          ),
        ],
      ),
      body: ProductGridWidget(),
    );
  }
}
