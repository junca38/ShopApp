import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/cart.dart' show Cart;
import 'package:ShopApp/widgets/cart_item_widget.dart';
import 'package:ShopApp/provider/orders.dart';

/// display the shoping cart screen
class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          ///display the amount have to pay
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  //SizedBox(width: 10),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButtonWidget(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          //display the list of items that are added to the cart
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  price: cart.items.values.toList()[index].price,
                  title: cart.items.values.toList()[index].title,
                  quantity: cart.items.values.toList()[index].quantity,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButtonWidget extends StatefulWidget {
  const OrderButtonWidget({@required this.cart});
  final Cart cart;
  @override
  _OrderButtonWidgetState createState() => _OrderButtonWidgetState();
}

class _OrderButtonWidgetState extends State<OrderButtonWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() => _isLoading = true);
              await context.read<Orders>().addOrder(
                  cartProducts: widget.cart.items.values.toList(),
                  total: widget.cart.totalAmount);
              setState(() => _isLoading = false);
              widget.cart.clear();
            },
      child: (_isLoading)
          ? CircularProgressIndicator()
          : Text(
              'ORDER',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
