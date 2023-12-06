import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grosaryshop/model/cart_model.dart';
import 'package:provider/provider.dart';

import '../components/grocery_items_tile.dart';
import 'cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
        },child: Icon(Icons.shopping_bag),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 45,
              ),
              // good morning
              Text("Good Morning"),
              SizedBox(
                height: 15,
              ),
              // let's order fresh items
              Text(
                "Les's fresh items for you",
                style: GoogleFonts.akatab(
                    fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              //divider
              Divider(
                thickness: 2,
                color: Colors.black,
              ),
              //fresh items + grid
              Expanded(child: Consumer<CartModel>(
                builder: (context, value, child) {
                  return GridView.builder(
                    itemCount: value.shopItems.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,childAspectRatio: 1/1.2),
                      itemBuilder: (context, index) {
                        return GroceryItemsTile(
                            itemName: value.shopItems[index][0],
                            price: value.shopItems[index][1],
                            imagePath: value.shopItems[index][2],
                        color: value.shopItems[index][3],
                        onPressed: (){
                          Provider.of<CartModel>(context,listen: false).addItemToCart(index);
                        });
                      });
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
