import 'package:badges/badges.dart' as badges;
import 'package:cartapp/helper/db_helper.dart';
import 'package:cartapp/model/cart_model.dart';
import 'package:cartapp/provider/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'KG',
    'Dozen',
    'KG',
    'Dozen',
    'KG',
    'KG',
    'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];

  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(value.getCounter().toString(),
                        style: TextStyle(color: Colors.white));
                  },
                ),
                // animationType: BadgeAnimationType.fade,
                // animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemCount: productName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: ClipOval(
                              child: Image(
                                image: NetworkImage(
                                    productImage[index].toString()),
                                width: 120,
                                height: 120,
                                fit: BoxFit.fill,
                              ),
                              // )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productUnit[index].toString() +
                                        " " +
                                        r"$" +
                                        productPrice[index].toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        print(index);
                                        print(index);
                                        print(productName[index].toString());
                                        print(productPrice[index].toString());
                                        print(productPrice[index]);
                                        print('1');
                                        print(productUnit[index].toString());
                                        print(productImage[index].toString());

                                        dbHelper!
                                            .insert(Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: productName[index]
                                                    .toString(),
                                                initialPrice:
                                                    productPrice[index],
                                                productPrice:
                                                    productPrice[index],
                                                quantity: 1,
                                                unitTag: productUnit[index]
                                                    .toString(),
                                                image: productImage[index]
                                                    .toString()))
                                            .then((value) {
                                          cart.addTotalPrice(double.parse(
                                              productPrice[index].toString()));
                                          cart.addCounter();

                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                'Product is added to cart'),
                                            duration: Duration(seconds: 1),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }).onError((error, stackTrace) {
                                          print("error" + error.toString());
                                          final snackBar = SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  'Product is already added in cart'),
                                              duration: Duration(seconds: 1));

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Center(
                                          child: Text(
                                            'Add to cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          )
                          // );
                        ]));
                  }),
            ),

            //  ListView.builder(
            //     itemCount: productName.length,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 mainAxisSize: MainAxisSize.max,
            //                 children: [
            //                   Image(
            //                     height: 100,
            //                     width: 100,
            //                     image: NetworkImage(
            //                         productImage[index].toString()),
            //                   ),
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Expanded(
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           productName[index].toString(),
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w500),
            //                         ),
            //                         SizedBox(
            //                           height: 5,
            //                         ),
            //                         Text(
            //                           productUnit[index].toString() +
            //                               " " +
            //                               r"$" +
            //                               productPrice[index].toString(),
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.w500),
            //                         ),
            //                         SizedBox(
            //                           height: 5,
            //                         ),
            //                         Align(
            //                           alignment: Alignment.centerRight,
            //                           child: InkWell(
            //                             onTap: () {
            //                               print(index);
            //                               print(index);
            //                               print(productName[index].toString());
            //                               print(productPrice[index].toString());
            //                               print(productPrice[index]);
            //                               print('1');
            //                               print(productUnit[index].toString());
            //                               print(productImage[index].toString());

            //                               dbHelper!
            //                                   .insert(Cart(
            //                                       id: index,
            //                                       productId: index.toString(),
            //                                       productName:
            //                                           productName[index]
            //                                               .toString(),
            //                                       initialPrice:
            //                                           productPrice[index],
            //                                       productPrice:
            //                                           productPrice[index],
            //                                       quantity: 1,
            //                                       unitTag: productUnit[index]
            //                                           .toString(),
            //                                       image: productImage[index]
            //                                           .toString()))
            //                                   .then((value) {
            //                                 cart.addTotalPrice(double.parse(
            //                                     productPrice[index]
            //                                         .toString()));
            //                                 cart.addCounter();

            //                                 final snackBar = SnackBar(
            //                                   backgroundColor: Colors.green,
            //                                   content: Text(
            //                                       'Product is added to cart'),
            //                                   duration: Duration(seconds: 1),
            //                                 );

            //                                 ScaffoldMessenger.of(context)
            //                                     .showSnackBar(snackBar);
            //                               }).onError((error, stackTrace) {
            //                                 print("error" + error.toString());
            //                                 final snackBar = SnackBar(
            //                                     backgroundColor: Colors.red,
            //                                     content: Text(
            //                                         'Product is already added in cart'),
            //                                     duration: Duration(seconds: 1));

            //                                 ScaffoldMessenger.of(context)
            //                                     .showSnackBar(snackBar);
            //                               });
            //                             },
            //                             child: Container(
            //                               height: 35,
            //                               width: 100,
            //                               decoration: BoxDecoration(
            //                                   color: Colors.green,
            //                                   borderRadius:
            //                                       BorderRadius.circular(5)),
            //                               child: const Center(
            //                                 child: Text(
            //                                   'Add to cart',
            //                                   style: TextStyle(
            //                                       color: Colors.white),
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         )
          )
        ],
      ),
    );
  }
}
