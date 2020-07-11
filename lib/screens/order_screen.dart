import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/orders.dart';
import 'package:ShopApp/widgets/order_item_widget.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) =>
            OrderItemWidget(order: orderData.orders[index]),
      ),
    );
  }
}
