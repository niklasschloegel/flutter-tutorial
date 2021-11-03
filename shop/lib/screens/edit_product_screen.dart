import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Title"),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_priceFocusNode),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Price"),
                    textInputAction: TextInputAction.next,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) => FocusScope.of(context)
                        .requestFocus(_descriptionFocusNode),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Description"),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
