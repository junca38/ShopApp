import 'package:ShopApp/provider/auth.dart';
import 'package:ShopApp/widgets/app_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/orders.dart';
import 'package:ShopApp/widgets/order_item_widget.dart';

/// screen to show pass orders
class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  //  bool _isLoading = false;
  // @override
  // void initState() {
  //   super.initState();
  //   _isLoading = true;
  //   context
  //       .read<Orders>()
  //       .fetchAndSetOrder()
  //       .then((_) => setState(() => _isLoading = false));
  // }

  /// get a list of pass order history
  /// using future builder, wait to finish and return the future
  /// once done, use listview.builder to build teh order list
  @override
  Widget build(BuildContext context) {
    //final orderData = context.watch<Orders>();
    final token = Provider.of<Auth>(context, listen: false).token;
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders')),
      drawer: AppDrawerWidget(),
      body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndSetOrder(token),
          builder: (context, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else {
              print('finished loading');
              if (dataSnapShot.error != null)
                return Center(child: Text('Error in getting order data'));
              else
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, index) =>
                        OrderItemWidget(order: orderData.orders[index]),
                  ),
                );
            }
          }),
    );
  }
}
