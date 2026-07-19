import 'package:flutter/material.dart';
import 'package:intellipharm/app_theme/theme_extension.dart';
import 'package:get/get.dart';

class OrderItemCard extends StatelessWidget {
  final dynamic item;
  final ThemeColors colors;

  const OrderItemCard({super.key, required this.item, required this.colors});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool hasDiscount = item.gift != 0;
    final String discount = hasDiscount
        ? "GIFT_QUANTITY".trParams({'gift': item.gift.toString()})
        : "";

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(size.height * 0.015),
          decoration: BoxDecoration(
            color: colors.component,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: size.height * 0.055,
                height: size.height * 0.055,
                decoration: BoxDecoration(
                  color: colors.backgroundMain,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  color: colors.textPrimary,
                ),
              ),

              SizedBox(width: size.height * 0.015),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.medicineName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "UNITS_COUNT".trParams({
                        'count': item.quantity.toString(),
                      }),
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontFamily: 'Cairo',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "PRICE_SP".trParams({
                  'price': item.totalPrice.toString(),
                }),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),

        if (hasDiscount)
          PositionedDirectional(
            top: 0,
            end: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.height * 0.01,
                vertical: size.height * 0.004,
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(16),
                  bottomStart: Radius.circular(12),
                ),
              ),
              child: Text(
                discount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
