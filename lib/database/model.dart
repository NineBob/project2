class Product {
  late String name;
  late double price;
  late String description;
  late int favorite;

  static const tableName = 'products';
  static const colName = 'name';
  static const colDescription = 'description';
  static const colPrice = 'price';
  static const colFavorite = 'favorite';

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.favorite,
  });

  Map<String, dynamic> toMap() {
    var mapData = <String, dynamic>{
      colName: name,
      colDescription: description,
      colPrice: price,
      colFavorite: favorite
    };
    return mapData;
  }
}
