import 'package:flutter_riverpod/legacy.dart';
import '../data/address_model.dart';

class AddressNotifier extends StateNotifier<List<AddressModel>> {
  AddressNotifier() : super([
    // Initializing with realistic data instead of empty state for UI testing
    AddressModel(
      id: '1', 
      title: 'Home', 
      address: '123 Nile Street, 6th of October City, Giza', 
      isDefault: true
    ),
    AddressModel(
      id: '2', 
      title: 'Office', 
      address: 'Smart Village, Building B, Giza', 
      isDefault: false
    ),
    AddressModel(
      id: '3', 
      title: 'Parent\'s House', 
      address: '45 Maadi Corniche, Cairo', 
      isDefault: false
    ),
  ]);

  // Method to set a new default address
  void setDefaultAddress(String id) {
    state = state.map((address) {
      if (address.id == id) {
        return address.copyWith(isDefault: true);
      } else {
        // Remove default from all other addresses
        return address.copyWith(isDefault: false); 
      }
    }).toList();
  }

  // Method to delete an address
  void deleteAddress(String id) {
    state = state.where((address) => address.id != id).toList();
  }

  // In the future, you will add: Future<void> fetchAddressesFromApi() here!
}

// The Provider exposed to the UI
final addressProvider = StateNotifierProvider<AddressNotifier, List<AddressModel>>((ref) {
  return AddressNotifier();
});