import 'package:flutter/material.dart';

class GroceryItemsTile extends StatelessWidget {
  final String itemName;
  final String price;
  final String imagePath;
  final color;
  final void Function()? onPressed;

  const GroceryItemsTile(
      {super.key,
      required this.itemName,
      required this.price,
      required this.imagePath,
      this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: color[100],
              borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //image
            Image.asset(imagePath,height: 64,),
            //itemName
            Text(itemName),
            //price + button
            MaterialButton(
              color: color,
              onPressed:onPressed,child: Text("\$" +price,style: TextStyle(
              color: Colors.white,fontWeight: FontWeight.w400,fontSize: 28,
            ),),)
          ],
        ),
      ),
    );
  }
}
