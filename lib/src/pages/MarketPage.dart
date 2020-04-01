import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:poemobile/src/components/PoeItemList.dart';
import 'package:poemobile/src/di/Injector.dart';
import 'package:poemobile/src/entities/MarketQuery.dart';
import 'package:poemobile/src/entities/MarketResult.dart';
import 'package:poemobile/src/entities/Pagination.dart';
import 'package:poemobile/src/entities/PoePictureItem.dart';
import 'package:poemobile/src/pages/CameraPreviewPage.dart';
import 'package:poemobile/src/providers/PictureMLScanner.dart';
import 'package:poemobile/src/repositories/MarketRepository.dart';

import 'PoeFilterPage.dart';

class MarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MarketPageState();
  }
}

class _MarketPageState extends State<MarketPage> {
  MarketRepository marketRepository = Injector().marketRepository;
  Page<ItemSearchResult> currentResult = Page(content: [], offset: 0, pageSize: 10, total: 0);

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
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              this._initializeCamera();
            },
          ),
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
              this._updateItemList();
            },
          )
        ],
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
                        decoration: InputDecoration(
                          labelText: "Search",
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                this.searchTerm.clear();
                              }
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    //child: _getFutureBuilder(),
                    child: Container(child: PoeItemListComponent(this.currentResult.content, () {
                      if (this.currentResult == null
                          || this.currentResult.queryId == null || this.currentResult.queryId == ""
                          || this.currentResult.total == 0
                          || this.currentResult.offset + this.currentResult.pageSize == this.currentResult.total) {
                        return;
                      }
                      this.marketRepository.fetchItemByQueryId(
                          queryId: this.currentResult.queryId,
                          offset: this.currentResult.offset+this.currentResult.pageSize
                      ).then((value) {
                        this.setState(() {
                          this.currentResult.content.addAll(value.content);
                          this.currentResult.offset = value.offset;
                          this.currentResult.pageSize = value.pageSize;
                        });
                      });
                    })),
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
      setState(() {
        PoePictureItem pictureItem = PoePictureItem(entries, vt);
        this.searchTerm.text = "${pictureItem.title} ${pictureItem.subtitle == null ? "" : pictureItem.subtitle}".trim();
        this.query.query.stats.first.filters.clear();
        this.query.query.stats.first.filters.addAll(pictureItem.mods);
      });
      this._updateItemList();
    });
  }

  void _updateItemList() {
    this.marketRepository
        .fetchItem(this.searchTerm.text, query: query)
        .then((value) => this.setState(() => this.currentResult = value));
  }
}
