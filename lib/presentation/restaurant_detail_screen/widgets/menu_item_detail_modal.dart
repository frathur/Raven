import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MenuItemDetailModal extends StatefulWidget {
  final Map<String, dynamic> menuItem;
  final VoidCallback onAddToCart;

  const MenuItemDetailModal({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
  });

  @override
  State<MenuItemDetailModal> createState() => _MenuItemDetailModalState();
}

class _MenuItemDetailModalState extends State<MenuItemDetailModal> {
  int quantity = 1;
  List<String> selectedCustomizations = [];
  String selectedSize = 'Regular';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.neutralGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large food image
                  CustomImageWidget(
                    imageUrl: widget.menuItem["image"] as String,
                    width: double.infinity,
                    height: 30.h,
                    fit: BoxFit.cover,
                  ),

                  // Item details
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name and price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.menuItem["name"] as String,
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryBlack,
                                ),
                              ),
                            ),
                            Text(
                              widget.menuItem["price"] as String,
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryBlack,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Full description
                        Text(
                          widget.menuItem["fullDescription"] as String? ??
                              widget.menuItem["description"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Size selection
                        if (widget.menuItem["sizes"] != null) ...[
                          Text(
                            'Size',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Wrap(
                            spacing: 2.w,
                            children:
                                (widget.menuItem["sizes"] as List).map((size) {
                              final sizeMap = size as Map<String, dynamic>;
                              final isSelected =
                                  selectedSize == sizeMap["name"];
                              return GestureDetector(
                                onTap: () => setState(() =>
                                    selectedSize = sizeMap["name"] as String),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppTheme.accentYellow
                                        : AppTheme.neutralGray,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.accentYellow
                                          : AppTheme.neutralGray,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        sizeMap["name"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: AppTheme.primaryBlack,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        sizeMap["price"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 3.h),
                        ],

                        // Customizations
                        if (widget.menuItem["customizations"] != null) ...[
                          Text(
                            'Customizations',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          ...(widget.menuItem["customizations"] as List)
                              .map((customization) {
                            final customMap =
                                customization as Map<String, dynamic>;
                            final isSelected = selectedCustomizations
                                .contains(customMap["name"]);
                            return CheckboxListTile(
                              title: Text(
                                customMap["name"] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium,
                              ),
                              subtitle: customMap["price"] != null
                                  ? Text(
                                      "+ ${customMap["price"]}",
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                    )
                                  : null,
                              value: isSelected,
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    selectedCustomizations
                                        .add(customMap["name"] as String);
                                  } else {
                                    selectedCustomizations
                                        .remove(customMap["name"]);
                                  }
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            );
                          }).toList(),
                          SizedBox(height: 3.h),
                        ],

                        // Nutritional info
                        if (widget.menuItem["nutrition"] != null) ...[
                          Text(
                            'Nutritional Information',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlack,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.neutralGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildNutritionItem(
                                    'Calories',
                                    widget.menuItem["nutrition"]["calories"]
                                        .toString()),
                                _buildNutritionItem('Protein',
                                    '${widget.menuItem["nutrition"]["protein"]}g'),
                                _buildNutritionItem('Carbs',
                                    '${widget.menuItem["nutrition"]["carbs"]}g'),
                                _buildNutritionItem('Fat',
                                    '${widget.menuItem["nutrition"]["fat"]}g'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryBlack,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowSubtle,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Quantity selector
            Container(
              decoration: BoxDecoration(
                color: AppTheme.neutralGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'remove',
                        color: AppTheme.primaryBlack,
                        size: 5.w,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                    child: Text(
                      quantity.toString(),
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlack,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => quantity++),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      child: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.primaryBlack,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 4.w),

            // Add to cart button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onAddToCart();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentYellow,
                  foregroundColor: AppTheme.primaryBlack,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add to Cart - ${_calculateTotalPrice()}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateTotalPrice() {
    // Simple calculation - in real app, this would be more complex
    final basePrice =
        double.parse(widget.menuItem["price"].toString().replaceAll('\$', ''));
    final total = basePrice * quantity;
    return '\$${total.toStringAsFixed(2)}';
  }
}
