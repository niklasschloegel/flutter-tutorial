import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: "", title: "", description: "", price: 0, imageUrl: "");
  var _isInit = true;
  var _initValues = {"title": "", "price": "", "description": ""};
  var _loading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context)?.settings.arguments as String?;
      if (prodId != null) {
        var prod =
            Provider.of<Products>(context, listen: false).findById(prodId);
        _editedProduct = prod;
        _initValues["title"] = _editedProduct.title;
        _initValues["price"] = _editedProduct.price.toString();
        _initValues["description"] = _editedProduct.description;
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      var text = _imageUrlController.text;
      if (text.isEmpty || !text.startsWith("http")) return;
      setState(() {});
    }
  }

  Future<Null> showError() => showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Error"),
          content: Text("Something went wrong."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text("Ok"),
            )
          ],
        ),
      );

  void _saveForm() async {
    final currentState = _form.currentState;
    if (currentState != null && currentState.validate()) {
      currentState.save();
      setState(() => _loading = true);

      try {
        if (_editedProduct.id.isEmpty) {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } else {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_editedProduct);
        }
      } catch (_) {
        await showError();
      } finally {
        setState(() => _loading = false);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: "Title"),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_priceFocusNode),
                          onSaved: (val) {
                            if (val != null) _editedProduct.title = val;
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? "Please enter a title"
                              : null,
                          initialValue: _initValues["title"],
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Price"),
                          textInputAction: TextInputAction.next,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),
                          onSaved: (val) {
                            if (val != null)
                              _editedProduct.price = double.parse(val);
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty)
                              return "Please enter a price";
                            if (double.tryParse(val) == null)
                              return "Please enter a valid number";
                            if (double.parse(val) <= 0)
                              return "Please enter a positive price";
                          },
                          initialValue: _initValues["price"],
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: "Description"),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          onSaved: (val) {
                            if (val != null) _editedProduct.description = val;
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty)
                              return "Please enter a description";
                            if (val.length < 10)
                              return "Should be at least 10 characters long";
                          },
                          initialValue: _initValues["description"],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text("Enter URL")
                                  : FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text),
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Image URL"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) => _saveForm(),
                                onSaved: (val) {
                                  if (val != null)
                                    _editedProduct.imageUrl = val;
                                },
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return "Please enter an image URL";
                                  if (!val.startsWith("http"))
                                    return "Please enter a valid URL";
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
