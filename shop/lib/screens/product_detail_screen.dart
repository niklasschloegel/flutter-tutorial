import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Scroll controller is for changing the Icon color in the App Bar
  // Source: https://stackoverflow.com/questions/53622598/changing-sliverappbar-title-color-in-flutter-application
  late ScrollController _scrollController;
  bool _lastStatus = true;

  bool get isShrink =>
      _scrollController.hasClients &&
      _scrollController.offset > (300 - kToolbarHeight);

  _scrollListener() {
    if (isShrink != _lastStatus) {
      setState(() {
        _lastStatus = isShrink;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffMessenger = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(
      context,
      listen: false,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<Cart>(context, listen: false)
              .addItem(product.id, product.price, product.title);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Item added to shopping cart")));
        },
        child: Icon(Icons.shopping_cart),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (ctx, innerBoxScrolled) => [
          SliverAppBar(
            onStretchTrigger: () async {
              print("OVERSCROLLED");
            },
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isShrink ? Colors.white : Colors.black,
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            actions: [
              Consumer<Product>(
                builder: (_, p, __) => IconButton(
                  onPressed: () {
                    final token = auth.token;
                    final userId = auth.userId;
                    if (token == null || userId == null) return;

                    product.toggleFavorite(token, userId).catchError((_) {
                      scaffMessenger.hideCurrentSnackBar();
                      scaffMessenger.showSnackBar(
                        SnackBar(
                          content: Text("Could not change favorite state"),
                        ),
                      );
                    });
                  },
                  icon: Icon(
                    p.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isShrink ? Colors.white : Colors.red,
                  ),
                ),
              )
            ],
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Text(
                  "\$${product.price}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
