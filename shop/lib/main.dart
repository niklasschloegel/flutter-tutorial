import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/products_overview_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products([]),
          update: (ctx, auth, prev) =>
              Products(prev == null ? [] : prev.items)..authToken = auth.token,
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders([]),
          update: (ctx, auth, prev) =>
              Orders(prev == null ? [] : prev.orders)..authToken = auth.token,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.indigo,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuthenticated ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (_) => ProductsOverviewScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            UserProductsScreen.routeName: (_) => UserProductsScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
