import 'package:flutter/material.dart';
import 'package:ShopApp/widgets/product_grid_widget.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/products.dart';
import 'package:ShopApp/provider/cart.dart';
import 'package:ShopApp/widgets/badge_widget.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                _showFavoritesOnly = (selectedValue == FilterOptions.Favorites);
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
          ),
          //adding badge
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: null,
            ),
          ),
        ],
      ),
      body: ProductGridWidget(_showFavoritesOnly),
    );
  }
}
