import 'package:ShopApp/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/products.dart';

/// custom widget to show the product in product owner screen to manage the product
class UserProductItemWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItemWidget({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // for the use of snackbarwidget
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            /// go to product edit screen to mange the product detail
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),

            /// to remove the product from system
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await context.read<Products>().deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('$e', textAlign: TextAlign.center),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
