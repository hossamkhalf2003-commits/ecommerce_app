class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      // Platzi sends price as an int, we convert it to double for safety
      price: (json['price'] as num).toDouble(), 
      description: json['description'],
      // JSON arrays come back as dynamic, so we cast them to Strings safely
      images: List<String>.from(json['images']), 
    );
  }
}