class AddressModel {
  final String id;
  final String title;
  final String address;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.address,
    this.isDefault = false,
  });

  // copyWith allows us to easily update the default status
  AddressModel copyWith({bool? isDefault}) {
    return AddressModel(
      id: id,
      title: title,
      address: address,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}