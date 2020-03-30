import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/pablolm/AndroidStudioProjects/poe_mobile/lib/src/pages/PoeFilterPage.dart';
import 'package:poemobile/src/components/PoeItemList.dart';
import 'package:poemobile/src/di/Injector.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/PoePictureItem.dart';
import 'package:poemobile/src/pages/CameraPreviewPage.dart';
import 'package:poemobile/src/providers/PictureMLScanner.dart';
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
        status: PoeMarketQueryStatus(option: "any"),
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
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => new PoeFilterPage(marketQuery: this.query, onQueryChange: (query) {
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
                  child: Center(child: CircularProgressIndicator())
              );
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
            builder: (context) => CameraPreviewPage(
              camera: description,
              onPictureTaken: _onPictureInfo,
            )));
  }

  void _onPictureInfo(VisionText vt) {
    this.marketRepository.fetchStats().then((entries) {
      PoePictureItem pictureItem = PoePictureItem(entries, vt);
      this.searchTerm.text = "${pictureItem.title} ${pictureItem.subtitle == null ? "" : pictureItem.subtitle}".trim();
      this.query.query.stats.first.filters.clear();
      this.query.query.stats.first.filters.addAll(pictureItem.mods);
      setState(() {});
    });
  }
}
