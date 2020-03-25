
class MarketResult {

  Item item;
}

class ItemSearchResult {
  Listing listing;
  Item item;

  ItemSearchResult({this.listing, this.item});

  factory ItemSearchResult.fromJson(Map<String, dynamic> parsedJson) {
    Item item = Item.fromJson(parsedJson["item"]);
    Listing listing = Listing.fromJson(parsedJson["listing"]);
    return ItemSearchResult(
      listing: listing,
      item: item,
    );
  }

  static List<ItemSearchResult> listFromJson(List<dynamic> parsedJson) {
    return parsedJson.map((e) => ItemSearchResult.fromJson(e)).toList();
  }

}

class Listing {
  String whisper;
  ListingAccount account;
  ListingPrice price;

  Listing({this.whisper, this.account, this.price});

  factory Listing.fromJson(Map<String, dynamic> parsedJson) {
    ListingAccount listingAccount = ListingAccount.fromJson(parsedJson["account"]);
    ListingPrice price = ListingPrice.fromJson(parsedJson["price"]);

    return Listing(
      whisper: parsedJson["whisper"],
      account: listingAccount,
      price: price,
    );
  }

}

class ListingAccount {
  String characterName;
  String lastCharacterName;

  ListingAccount({this.characterName, this.lastCharacterName});

  factory ListingAccount.fromJson(Map<String, dynamic> parsedJson) {
    return ListingAccount(
      characterName: parsedJson["name"],
      lastCharacterName: parsedJson["lastCharacterName"]
    );
  }
}

class ListingPrice {
  String type;
  int amount;
  String currency;

  ListingPrice({this.type, this.amount, this.currency});

  factory ListingPrice.fromJson(Map<String, dynamic> parsedJson) {
    return ListingPrice(
      amount: parsedJson["amount"],
      currency: parsedJson["currency"],
      type: parsedJson["type"],
    );
  }
}

class Item {
  String typeLine;
  String name;
  String icon;
  String league;
  List<ItemSockets> sockets;
  bool identified;
  int ilvl;
  List<ItemProperty> properties;
  List<ItemProperty> requirements;
  List<dynamic> explicitMods;
  bool corrupted;

  Item({this.typeLine, this.name, this.icon, this.sockets, this.identified, this.ilvl, this.properties, this.requirements, this.explicitMods, this.corrupted});

  factory Item.fromJson(Map<String, dynamic> parsedJson) {
    return Item(
      typeLine: parsedJson["typeLine"],
      name: parsedJson["name"],
      icon: parsedJson["icon"],
      identified: parsedJson["identified"],
      ilvl: parsedJson["ilvl"],
      properties: ItemProperty.fromJson(parsedJson["properties"]),
      requirements: ItemProperty.fromJson(parsedJson["requirements"]),
      explicitMods: parsedJson["explicitMods"],
      sockets: ItemSockets.fromJson(parsedJson["sockets"]),
      corrupted: parsedJson["corrupted"],
    );
  }

  static List<Item> listFromJson(List<dynamic> list) {
    return list.map((e) => Item.fromJson(e)).toList();
  }
}

class ItemProperty {
  String name;
  List<dynamic> values;

  ItemProperty({this.name, this.values});

  static List<ItemProperty> fromJson(List<dynamic> parsedJson) {
    List<ItemProperty> properties = [];
    if (parsedJson == null) {
      return properties;
    }
    parsedJson.forEach((element) {
      properties.add(ItemProperty(
        name: element["name"],
        values: element["values"],
      ));
    });
    return properties;
  }
}

class ItemSockets {
  int group;
  String attr;
  String color;

  ItemSockets({this.group, this.attr, this.color});

  static List<ItemSockets> fromJson(List<dynamic> parsedJson) {
    List<ItemSockets> sockets = [];
    if (parsedJson == null) {
      return sockets;
    }
    parsedJson.forEach((element) {
      sockets.add(ItemSockets(
        color: element["color"],
        attr: element["attr"],
        group: element["group"]
      ));
    });
    return sockets;
  }
}