import 'package:ShopApp/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// show product details, which has title, price, description, image
class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/Product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    //provider old v3 method, atm don't have better way to just load once in v4
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                /// show title
                title: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text(loadedProduct.title),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromRGBO(128, 128, 128, 0.8),
                  ),
                ),

                /// show image
                background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10),

                /// show price
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                ///show description
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ]),
            ),
          ],
          // child: Column(
          //   children: <Widget>[
          //     Container(
          //       height: 300,
          //       width: double.infinity,
          //       child:
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
