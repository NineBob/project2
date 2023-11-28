import 'package:flutter/material.dart';
import 'package:project2/database/database_helper.dart';
import '../database/model.dart';

// ignore: must_be_immutable
class ProductScreen extends StatefulWidget {
  ProductScreen({Key? key, required this.products, required this.dbHelper})
      : super(key: key);

  List<Product> products;
  DatabaseHelper dbHelper;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                var result = await ModalProductForm(
                    products: widget.products, dbHelper: widget.dbHelper)
                    .showModalInputForm(context);
                setState(() {
                  if (result != null) {
                    widget.products = result;
                  }
                });
              },
              icon: const Icon(Icons.add_comment)),
          //IconButton(onPressed:var d=1; , icon:const Icon(Icons. ))
        ],
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (context, index) {

          // ** Edit ** Wrap this Card with Dismissible widget for swipable
          return Dismissible(
            key: UniqueKey(),
            background: Container(color:Colors.blue),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 30),
              child: const Icon(Icons.delete_outlined,color: Colors.white,size: 30),
            ),
            direction: DismissDirection.horizontal,

            child: ListTile(
              title: Text(widget.products[index].name),
              subtitle:
              Text('Price: ${widget.products[index].price.toString()}'),
              trailing: widget.products[index].favorite == 1
                  ? const Icon(Icons.favorite_rounded, color: Colors.red)
                  : null,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(productdetail: widget.products[index]),
                  ),
                );
                setState(() {
                  if (result != null) {
                    widget.products[index].favorite = result;
                    widget.dbHelper.updateProduct(widget.products[index]);
                    // ** Edit : Call update method here (for favorite flag)
                  }
                });
              },
              onLongPress:() async{
                var result = await ModalEditproductForm(
                    productDetail: widget.products[index],
                    dbHelper: widget.dbHelper).showModalInputForm(context);
                setState(() {
                  if(result!=null){
                    widget.products[index]=result;
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.productdetail}) : super(key: key);

  final Product productdetail;

  @override
  Widget build(BuildContext context) {
    var result = productdetail.favorite;
    return Scaffold(
      appBar: AppBar(
        title: Text(productdetail.name),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: Text(productdetail.description),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, top: 20.0),
            child: Text('Price: ${productdetail.price.toString()}'),
          ),
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 40),
                      backgroundColor: productdetail.favorite == 1
                          ? Colors.blueGrey
                          : Colors.redAccent),
                  child: productdetail.favorite == 1
                      ? const Text('Unfavorite')
                      : const Text('Favorite'),
                  onPressed: () {
                    result = productdetail.favorite == 1 ? 0 : 1;
                    Navigator.pop(context, result);
                  },
                ),
                ElevatedButton(
                  child: const Text('Close'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 40),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Modify this class
// Fixed: virtual keyboard show and hide suddenly
//   1. remove Form widget
//   2. add isScrollControlled: true, in properties of showModalBottomSheet
//   3. wrap builder with Container
//      padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//   4. add autofocus: true at the first input field for force to show virtual keyboard
//
class ModalProductForm {
  ModalProductForm({Key? key, required this.products, required this.dbHelper});

  List<Product> products;
  DatabaseHelper dbHelper;

  String _name = '', _description = '';
  double _price = 0;
  final int _favorite = 0;

  Future<dynamic> showModalInputForm(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Center(
                    child: Text(
                      'Product input Form',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: '',
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'input your name of product',
                        ),
                        onChanged: (value) {
                          _name = value;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: '',
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'input description of product',
                        ),
                        onChanged: (value) {
                          _description = value;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: '',
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'input price',
                        ),
                        onChanged: (value) {
                          _price = double.parse(value);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: ElevatedButton(
                          child: const Text('Add'),
                          onPressed: () async {
                            var newProduct = Product(
                                name: _name,
                                description: _description,
                                price: _price,
                                favorite: _favorite);
                            products.add(newProduct);
                            await dbHelper.insertProduct(newProduct);
                            Navigator.pop(context, products);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
class ModalEditproductForm {
  ModalEditproductForm({Key? key, required this.productDetail, required this.dbHelper});

  Product productDetail;
  DatabaseHelper dbHelper;

  String _name = '', _description = '';
  double _price = 0;
  int _favorite = 0;

  Future<dynamic> showModalInputForm(BuildContext context) {
    _favorite=productDetail.favorite;
    _name=productDetail.name;
    _price=productDetail.price;
    _description=productDetail.description;

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Center(
                    child: Text(
                      'Product input Form',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        readOnly: true,
                        initialValue: productDetail.name,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                          hintText: 'input your name of product',
                        ),
                        onChanged: (value) {

                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: productDetail.description,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'input description of product',
                        ),
                        onChanged: (value) {
                          _description = value;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: TextFormField(
                        initialValue: productDetail.price.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'input price',
                        ),
                        onChanged: (value) {
                          _price = double.parse(value);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: ElevatedButton(
                          child: const Text('update'),
                          onPressed: () async {
                            var newProduct = Product(
                                name: _name,
                                description: _description,
                                price: _price,
                                favorite: _favorite);

                            await dbHelper.updateProduct(newProduct);
                            Navigator.pop(context, newProduct);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

// ** #Edit Add ModalEditProductForm here !!!