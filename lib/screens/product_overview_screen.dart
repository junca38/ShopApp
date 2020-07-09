import 'package:flutter/material.dart';
import 'package:ShopApp/widgets/product_grid_widget.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop App'),
      ),
      body: ProductGridWidget(),
    );
  }
}
