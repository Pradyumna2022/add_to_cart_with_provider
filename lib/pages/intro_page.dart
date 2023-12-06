import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grosaryshop/pages/home_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              SizedBox(height: 50,),
              Image.asset('assets/images/avocado.png'),
              SizedBox(height: 20,),
              // items to your door step
              Text("We deliver all items at your doorstep",
                style: GoogleFonts.notoSerif(
                  fontSize: 35,fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              //fresh items everyday
              Text("Fresh items everyday",style: TextStyle(
                  color: Colors.grey,fontSize: 18
              ),),
              Spacer(),
              //get started button
              GestureDetector(
                onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                child: Container(
                  width: 150,
                  height: 80,
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.green,borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text("Get Started",style: TextStyle(
                      color: Colors.white,fontSize: 14
                    ),),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
