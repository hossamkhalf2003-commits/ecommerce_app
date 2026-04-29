import 'package:flutter_riverpod/legacy.dart';
import '../data/order_model.dart';
import '../../cart/data/cart_item_model.dart';

class OrderNotifier extends StateNotifier<List<OrderModel>> {
  OrderNotifier() : super([]);

  // This method gets called by the Checkout Screen!
  void placeOrder(List<CartItem> cartItems, double totalAmount) {
    // 1. Generate a fake order ID (e.g., ORD-1698745)
    final String orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    // 2. Create the order object
    final newOrder = OrderModel(
      id: orderId,
      date: DateTime.now(),
      items: List.from(cartItems), // We create a strict copy of the cart items!
      totalAmount: totalAmount,
    );

    // 3. Add it to the TOP of the state list (newest first)
    state = [newOrder, ...state];
  }
}

// The Provider we will watch in the UI
final orderProvider = StateNotifierProvider<OrderNotifier, List<OrderModel>>((ref) {
  return OrderNotifier();
});