import 'package:flutter/material.dart';

import '../app_theme/theme_extension.dart';

class MedicineItemCard extends StatelessWidget {
  final String name;
  final double price;
  final double unitPrice;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const MedicineItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.unitPrice,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.width * 0.01),
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right:  size.width * 0.03),
                child: Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: size.width * 0.01),

          Text(
            "Unit Price: \$${unitPrice.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),

          SizedBox(height: size.width * 0.02),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.006),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: onDecrease,
                          icon: const Icon(Icons.remove, color: Colors.black),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          iconSize: 20,
                        ),
                      ),
                    ),
                    /*    Expanded(
                      child: Center(
                        child: Text(
                          quantity.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),*/
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          //fontSize: size.width * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.006),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: onDecrease,
                          icon: const Icon(Icons.add, color: Colors.black),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          iconSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// remove button
              TextButton(
                onPressed: onRemove,
                child: const Text(
                  "Remove",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
