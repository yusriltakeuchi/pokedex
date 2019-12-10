import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/viewmodels/pokedex_provider.dart';
import 'package:pokedex/ui/widgets/loading_animation.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex"),
        backgroundColor: Colors.blue,
      ),

      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (context) => PokedexProvider(),
          )
        ],
        child: HomeBody(),
      )
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  ScrollController scrollController;
  //Scroll detection when scroll reached bottom
  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      //When scroll reach end then fetch new pokemon again
      final prov = Provider.of<PokedexProvider>(context);
      if (prov.getFetching == false) {
        prov.setFetching(true);
        prov.getPokemon();
      }
    }
  }

  @override
  void initState() {
    scrollController = new ScrollController();
    scrollController.addListener(_scrollListener);

    //initialize super state
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final pokedexProv = Provider.of<PokedexProvider>(context);
    if (pokedexProv.getPokedex == null) {
      //First initializing apps load 10 data
      pokedexProv.getPokemon();
    }

    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Pokemon List",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(
              height: 20,
            ),
            pokedexProv.getPokedex.length > 0 ? 
              PokedexList() 
            : Center(
              child: LoadingAnimation(),
            )
          ],
        ),
      ),
    );
  }
}

class PokedexList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Use consumer to make a widget listening to provider
    return Consumer<PokedexProvider>(
      builder: (context, pokedexProv, child) {
       
        return Column(
          children: <Widget>[
            Container(
              child: ListView.builder(
                itemCount: pokedexProv.getPokedex.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index) {
                  
                  var data = pokedexProv.getPokedex[index];
                  return Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(11),
                          
                          //Adding shadow to container
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 15,
                              color: Colors.black26, 
                              offset: Offset(5.0, 5.0)
                            )
                          ]
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 120,
                              height: 120,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    color: Colors.blue,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 15,
                                        color: Colors.black26, 
                                        offset: Offset(5.0, 5.0)
                                      )
                                    ],
                                    gradient: LinearGradient(
                                      // Where the linear gradient begins and ends
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      // Add one stop for each color. Stops should increase from 0 to 1
                                      stops: [0.1, 0.5, 0.7, 0.9],
                                      colors: [
                                        // Colors are easy thanks to Flutter's Colors class.
                                        Colors.blue[700],
                                        Colors.blue[500],
                                        Colors.blue[400],
                                        Colors.blue[200],
                                      ],
                                    )
                                  ),
                                  child: Image.network(data.image, fit: BoxFit.cover,)
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset("images/icon_weight.svg", width: 20, height: 20, color: Colors.black54,),
                                        SizedBox(width: 5,),
                                        Text(
                                          data.weight.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54
                                          ),
                                        )
                                      ],
                                    ),
                                    
                                    SizedBox(
                                      width: 10,
                                    ),

                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset("images/icon_height.svg", width: 20, height: 20, color: Colors.black54,),
                                        SizedBox(width: 5,),
                                        Text(
                                          data.height.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                )
                              ],
                            ),
                          ],
                        )
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                },
              ),
            ),

            pokedexProv.getFetching == true ? Center(
              child: CircularProgressIndicator(),
            ) : Container()
          ],
        );
      },
    );
  }
}