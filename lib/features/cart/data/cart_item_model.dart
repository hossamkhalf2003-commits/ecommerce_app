import '../../home/data/product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;

  CartItem({
    required this.product,
    this.quantity = 1, // Default to 1 when added
  });

  // Riverpod requires "Immutable" state. 
  // We use copyWith to create a new updated item instead of modifying the old one.
  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  // A handy getter to instantly calculate the price of this specific row
  double get totalPrice => product.price * quantity;
}