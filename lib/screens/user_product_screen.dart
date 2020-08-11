import 'package:ShopApp/screens/edit_product_screen.dart';
import 'package:ShopApp/widgets/app_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/products.dart';
import 'package:ShopApp/widgets/user_product_item_widget.dart';

/// display the page that user can manage their own products
/// a.) add a new product
/// b.) modify existing products
/// c.) delete product
class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  /// call the logics to get and refresh the list of products
  Future<void> _refreshProducts(BuildContext context) async {
    await context.read<Products>().fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = context.watch<Products>();
    print('build product');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          /// button to add new product
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
          ),
        ],
      ),
      drawer: AppDrawerWidget(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),

                    /// get the list of products to manage
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) => Column(
                            children: <Widget>[
                              UserProductItemWidget(
                                id: productsData.items[index].id,
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
