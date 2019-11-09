import 'package:flutter/material.dart';
import 'package:pokedex/ui/screen/home_screen.dart';


/* 

  Name: Pokedex 
  Author: Yusril Rapsanjani
  Description: This is an applications for fetching
  pokemon data from API and showed in Listview with
  infinity scrolling

*/
void main() => runApp(MaterialApp(
  title: "Pokedex",
  home: HomeScreen(),
  debugShowCheckedModeBanner: false,
));
