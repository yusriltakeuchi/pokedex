import 'package:dio/dio.dart';
import 'package:pokedex/core/config/config.dart';

class PokedexServices {

  static Future fetchPokemon(String page) async {
    Dio dio = new Dio();
    var response = await dio.get(
      Config.endPointPokemon + "/${page}",
      options: Options(
        headers: {
          "Accept": "application/json"
        }
      )
    );

    return response.data;
  }

}