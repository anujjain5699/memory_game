import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memory_game/data/data.dart';
import 'data/data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pairs=getPairs();
    pairs.shuffle();

    visiblePairs=pairs;
    selected=true;
    Future.delayed(Duration(seconds: 5),(){
      setState(() {
        visiblePairs=getQuestions();
        selected=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 40,),
            points!=800? Column(
              children: [
                Text("$points/800",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),
                Text("Points",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              ],
            ):Container(),
            SizedBox(height: 20,),
            points!=800?GridView(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 0.7,childAspectRatio:1,
                maxCrossAxisExtent: 100,
              ),
              children: List.generate(visiblePairs.length, (index){
                return Tile(
                  imageAssetPath: visiblePairs[index].getImageAssetPath(),parent: this,
                  tileIndex: index,
                );
              }),
            ):Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24)
              ),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    points=0;
                  });
                },
                child: Text("Replay",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.white,
                ),),
              ),
            ),
            SizedBox(height: 40,),
            Container(
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(8),
                 shape: BoxShape.rectangle,
                image: DecorationImage(image: AssetImage("assets/1.png"),fit: BoxFit.cover)
              ),
              child: Text(
                 "   After tap Wait for a while !     ",
                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w800),textAlign: TextAlign.center,textScaleFactor: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {

  String imageAssetPath;
  int tileIndex;

  _HomePageState parent;
  Tile({this.imageAssetPath,this.parent,this.tileIndex});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(selectedImageAssetPath!=""){
          if(selectedImageAssetPath==pairs[widget.tileIndex].getImageAssetPath()){
            //correct
            print("correct");
            selected=true;
            Future.delayed(const Duration(seconds: 1),(){
              points=points+100;
              setState(() {
              });
              selected=false;
              widget.parent.setState(() {
                pairs[widget.tileIndex].setImageAssetPath("");
                pairs[selectedTileIndex].setImageAssetPath("");
              });
              selectedImageAssetPath="";
            });
          }
          else{
            //wrong choice
            print("wrongchoice");
            selected=true;
            Future.delayed(const Duration(seconds: 2),(){
              selected=false;
             widget.parent.setState(() {
               pairs[widget.tileIndex].setIsSelected(false);
               pairs[selectedTileIndex].setIsSelected(false);
             });
             selectedImageAssetPath="";
            });
          }
        }else{
          selectedTileIndex=widget.tileIndex;
          selectedImageAssetPath=pairs[widget.tileIndex].getImageAssetPath();
        }
        setState(() {
          pairs[widget.tileIndex].setIsSelected(true);
        });
        if(!selected){
          print("clicked");
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: pairs[widget.tileIndex].getImageAssetPath()!=""?Image.asset(pairs[widget.tileIndex].getIsSelected()?pairs[widget.tileIndex].getImageAssetPath():widget.imageAssetPath)
            :Image.asset("assets/correct.png")
      ),
    );
  }
}
