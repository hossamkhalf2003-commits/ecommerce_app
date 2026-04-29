import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../home/data/product_model.dart';
import '../data/cart_item_model.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  // We start with an empty list []
  CartNotifier() : super([]);

  // --- 1. ADD TO CART ---
  void addToCart(ProductModel product) {
    // Check if the product is already in the cart
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // If it exists, grab the list, increase the quantity by 1, and update the state
      final updatedCart = List<CartItem>.from(state);
      updatedCart[existingIndex] = updatedCart[existingIndex].copyWith(
        quantity: updatedCart[existingIndex].quantity + 1,
      );
      state = updatedCart;
    } else {
      // If it's new, use the spread operator (...) to add it to the end of the list
      state = [...state, CartItem(product: product)];
    }
  }

  // --- 2. DECREASE QUANTITY ---
  void decrementItem(int productId) {
    final existingIndex = state.indexWhere((item) => item.product.id == productId);
    if (existingIndex >= 0) {
      final currentItem = state[existingIndex];
      if (currentItem.quantity > 1) {
        // Decrease by 1
        final updatedCart = List<CartItem>.from(state);
        updatedCart[existingIndex] = currentItem.copyWith(quantity: currentItem.quantity - 1);
        state = updatedCart;
      } else {
        // If it drops to 0, remove it entirely
        removeItem(productId);
      }
    }
  }

  // --- 3. REMOVE ITEM ---
  void removeItem(int productId) {
    // Filter out the item with the matching ID
    state = state.where((item) => item.product.id != productId).toList();
  }
}

// --- PROVIDERS ---

// 1. The main Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// 2. The Total Price Provider (A Riverpod Superpower!)
// This automatically calculates the grand total of the entire cart anytime the cart changes.
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0.0, (total, item) => total + item.totalPrice);
});