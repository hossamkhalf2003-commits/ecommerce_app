import '../../cart/data/cart_item_model.dart';

class OrderModel {
  final String id; // A unique receipt number
  final DateTime date;
  final List<CartItem> items; // The snapshot of what they bought
  final double totalAmount;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
  });
}