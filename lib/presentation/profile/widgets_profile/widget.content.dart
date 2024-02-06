import 'package:flutter/material.dart';

Widget buildContent(){
  return const Column(children: [
    SizedBox(height: 18,),
    Text('James Summer',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
    SizedBox(height: 8,),
    Text('Flutter Software Developer',style: TextStyle(fontSize: 20),)
  ]);
}