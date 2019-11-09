
import 'package:flutter/material.dart';
import 'package:pokedex/core/models/pokedex_model.dart';
import 'package:pokedex/core/services/pokedex_services.dart';

class PokedexProvider extends ChangeNotifier {
  List<PokedexModel> pokedexList;
  List<PokedexModel> get getPokedex => pokedexList;

  int page = 0;
  bool isFetching = false;
  bool get getFetching => isFetching;

  Future<void> getPokemon() async {
    //Initialize data
    if (pokedexList == null) {
      pokedexList = new List<PokedexModel>();
    }

    for(int i=1; i<10; i++) {
      page++;
      print("Getting data from page ${page.toString()}");

      //Get data from API
      var data = await PokedexServices.fetchPokemon(page.toString());
      if (data != null) {
        //Assign to datalist
        pokedexList.add(PokedexModel.fromJson(data));
      }
    }

    //Notify to all listener widget
    isFetching = false;
    notifyListeners();
  }

  Future<void> setFetching(bool value) {
    isFetching = value;
    notifyListeners();
  }

}