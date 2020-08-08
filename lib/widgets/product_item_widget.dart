import 'package:ShopApp/provider/auth.dart';
import 'package:ShopApp/provider/cart.dart';
import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/product.dart';

/// to handle how the product display at the main screen
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
        /// go to product detail page when user taps on the product item
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productItem.id);
          },

          /// show product image
          child: Hero(
            tag: productItem.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(productItem.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),

        ///show footer: flavorite icon, product title, add to cart button
        footer: GridTileBar(
          backgroundColor: Colors.black87,

          /// flavorite icon
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

          /// product title
          title: Text(
            productItem.title,
            textAlign: TextAlign.center,
          ),

          /// add to cart button
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

              /// snackbar to show info and undo button after product is added to cart
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
