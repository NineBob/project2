class Product {
  late String name;
  late double price;
  late String description;
  late DateTime time;
  late int favorite;

  static const tableName = 'products';
  static const colName = 'name';
  static const colDescription = 'description';
  static const coltime = 'time';
  static const colPrice = 'price';
  static const colFavorite = 'favorite';

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.time,
    required this.favorite,
  });

  Map<String, dynamic> toMap() {
    var mapData = <String, dynamic>{
      colName: name,
      colDescription: description,
      colPrice: price,
      colFavorite: favorite,
      coltime:time
    };
    return mapData;
  }
}
