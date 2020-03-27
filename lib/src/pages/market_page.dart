import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/pablolm/AndroidStudioProjects/poe_mobile/lib/src/pages/poe_filter_page.dart';
import 'package:poemobile/src/components/poe_item_list.dart';
import 'package:poemobile/src/di/Injector.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/PoePictureItem.dart';
import 'package:poemobile/src/pages/camera_page.dart';
import 'package:poemobile/src/providers/ml_scanner_utils.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';

class MarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MarketPageState();
  }
}

class _MarketPageState extends State<MarketPage> {
  MarketRepository marketRepository = Injector().marketRepository;

  // For searcher
  TextEditingController searchTerm = TextEditingController(text: "");
  PoeMarketQuery query = PoeMarketQuery(
      query: PoeMarketQuerySpec(
        term: "",
        status: PoeMarketQueryStatus(option: "online"),
        stats: <PoeMarketStatsFilter>[
          PoeMarketStatsFilter(
              type: "and", filters: <PoeMarketStatsFilterSpec>[])
        ],
      ),
      sort: PoeMarketQuerySort(price: "asc"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Market"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.format_list_bulleted),
            color: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => new PoeFilterPage(query: this.query,onQueryChange: (query) {
                  this.query = query;
                  this.setState(() { });
                }),
              ));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              this.setState(() {});
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () {
          this._initializeCamera();
        },
      ),
      body: new Container(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Center(
            child: RefreshIndicator(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextField(
                        controller: this.searchTerm,
                        decoration: InputDecoration(labelText: "Search"),
                      )
                    ],
                  ),
                  Expanded(
                    child: _getFutureBuilder(),
                  ),
                ],
              ),
              onRefresh: () async {
                this.setState(() {});
              },
            ),
          )),
    );
  }
  FutureBuilder _getFutureBuilder() {
    return FutureBuilder(
        future: this.marketRepository.fetchItem(this.searchTerm.text, query: query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return new Container(
                  child: Text('Loading...'), padding: EdgeInsets.all(12.0));
            default:
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}');
              } else {
                //return _createListView(context, snapshot);
                return Container(child: PoeItemListComponent(snapshot.data));
              }
          }
        });
  }

  void _initializeCamera() async {
    final CameraDescription description =
    await ScannerUtils.getCamera(CameraLensDirection.back);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MLCameraCatcher(
              camera: description,
              onPictureTaken: _onPictureInfo,
            )));
  }

  void _onPictureInfo(VisionText vt) {
    PoePictureItem pictureItem = PoePictureItem(vt);
    this.searchTerm.text = "${pictureItem.title} ${pictureItem.subtitle == null ? "" : pictureItem.subtitle}".trim();
    setState(() {});
  }
}
