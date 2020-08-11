import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/cart.dart';

/// custom widget to display items in cart screen
class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemWidget(
      {this.id, this.title, this.price, this.quantity, this.productId});

  @override
  Widget build(BuildContext context) {
    ///swip left to remove a product item from the cart list
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        /// dialog to confirm if user want to remove the item from the cart
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: (Text('Are you sure?')),
            content: Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              FlatButton(
                  child: Text('NO'),
                  onPressed: () => Navigator.of(ctx).pop(false)),
              FlatButton(
                  child: Text('YES'),
                  onPressed: () => Navigator.of(ctx).pop(true))
            ],
          ),
        );
      },
      onDismissed: (direction) {
        context.read<Cart>().removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),

      /// card to display a particular product's info and quantity in shopping cart
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
