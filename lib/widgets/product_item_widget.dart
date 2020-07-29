import 'package:ShopApp/provider/auth.dart';
import 'package:ShopApp/provider/cart.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/product.dart';

class ProductItemWidget extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

// ProductItemWidget({this.id, this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productItem.id);
          },
          child: Hero(
            tag: productItem.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(productItem.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, productItem, child) => IconButton(
              icon: Icon(
                (productItem.isFavorite)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                productItem.toggleFavoriteStatus(
                    authData.token, authData.userId);
              },
            ),
          ),
          title: Text(
            productItem.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addItem(
                  productId: productItem.id,
                  title: productItem.title,
                  price: productItem.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart.'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(productItem.id);
                    },
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
