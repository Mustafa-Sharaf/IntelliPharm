
import '../AddOrder/AddOrder_Model.dart';

class CartItem {
  final MedicineModel medicine;
  int quantity;

  CartItem({
    required this.medicine,
    required this.quantity,
  });

  double get totalPrice =>
      (medicine.price ?? 0) * quantity;
}