import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id),
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text(
                          "Do you want to remove the item from your shop?"),
                      actions: [
                        TextButton(
                          child: Text(
                            "Abort",
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.onSurface,
                            ),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(false),
                        ),
                        TextButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Theme.of(ctx).errorColor,
                            ),
                          ),
                          onPressed: () => Navigator.of(ctx).pop(true),
                        )
                      ],
                    ),
                  ).then((value) {
                    if (value is bool && value == true)
                      return Provider.of<Products>(context, listen: false)
                          .deleteProduct(id);
                  }).catchError((_) {
                    scaffoldMessenger.showSnackBar(SnackBar(
                        content: Text(
                            "Something went wrong, item could not be deleted.")));
                  });
                },
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor),
          ],
        ),
      ),
    );
  }
}
