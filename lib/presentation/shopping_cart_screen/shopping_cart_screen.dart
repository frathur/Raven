import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cart_item_card.dart';
import './widgets/delivery_address_selector.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_card.dart';
import './widgets/promo_code_input.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;
  bool _isPromoLoading = false;
  String _currentPromoCode = '';
  double _promoDiscount = 0.0;

  // Mock cart data
  List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Margherita Pizza",
      "restaurant": "Tony's Italian Kitchen",
      "price": "\$18.99",
      "priceValue": 18.99,
      "quantity": 2,
      "image":
          "https://images.pexels.com/photos/315755/pexels-photo-315755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "customizations": "Extra cheese, Thin crust"
    },
    {
      "id": 2,
      "name": "Chicken Teriyaki Bowl",
      "restaurant": "Asian Fusion Express",
      "price": "\$14.50",
      "priceValue": 14.50,
      "quantity": 1,
      "image":
          "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "customizations": null
    },
    {
      "id": 3,
      "name": "Caesar Salad",
      "restaurant": "Green Garden Cafe",
      "price": "\$12.75",
      "priceValue": 12.75,
      "quantity": 1,
      "image":
          "https://images.pexels.com/photos/1059905/pexels-photo-1059905.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "customizations": "No croutons, Extra dressing"
    }
  ];

  final String _deliveryAddress =
      "123 Tech Street, Downtown District, San Francisco, CA 94105";
  final String _estimatedDeliveryTime = "25-30 minutes";

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return _cartItems.fold(
        0.0,
        (sum, item) =>
            sum + ((item['priceValue'] as double) * (item['quantity'] as int)));
  }

  double get _deliveryFee => 3.99;
  double get _taxes => _subtotal * 0.0875; // 8.75% tax rate
  double get _total => _subtotal + _deliveryFee + _taxes - _promoDiscount;

  void _removeItem(int itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == itemId);
    });

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      HapticFeedback.mediumImpact();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // In a real app, this would restore the item
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item restored to cart')),
            );
          },
        ),
      ),
    );
  }

  void _updateQuantity(int itemId, int newQuantity) {
    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item['id'] == itemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex]['quantity'] = newQuantity;
      }
    });
  }

  void _applyPromoCode(String promoCode) {
    setState(() {
      _isPromoLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isPromoLoading = false;
        _currentPromoCode = promoCode;

        if (promoCode.isNotEmpty) {
          // Mock discount calculation
          switch (promoCode) {
            case 'SAVE10':
              _promoDiscount = _subtotal * 0.10;
              break;
            case 'WELCOME20':
              _promoDiscount = _subtotal * 0.20;
              break;
            case 'DRONE15':
              _promoDiscount = _subtotal * 0.15;
              break;
            case 'FIRST25':
              _promoDiscount = _subtotal * 0.25;
              break;
            default:
              _promoDiscount = 0.0;
          }
        } else {
          _promoDiscount = 0.0;
        }
      });
    });
  }

  void _clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
            'Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.surfaceWhite,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(context, '/checkout-screen');
    });
  }

  void _changeAddress() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.neutralGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'Change Delivery Address',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.accentYellow,
                          size: 24,
                        ),
                        title: const Text('Use Current Location'),
                        subtitle:
                            const Text('Automatically detect your location'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Location updated')),
                          );
                        },
                      ),
                      ListTile(
                        leading: CustomIconWidget(
                          iconName: 'add_location',
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                        title: const Text('Add New Address'),
                        subtitle: const Text('Enter a new delivery address'),
                        onTap: () {
                          Navigator.pop(context);
                          // In real app, would open address form
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: _cartItems.isNotEmpty
            ? [
                TextButton(
                  onPressed: _clearCart,
                  child: Text(
                    'Clear',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.errorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
      bottomNavigationBar:
          _cartItems.isNotEmpty ? _buildCheckoutButton() : null,
    );
  }

  Widget _buildEmptyCart() {
    return EmptyCartWidget(
      onBrowseRestaurants: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-screen',
          (route) => false,
        );
      },
    );
  }

  Widget _buildCartContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 1.h),
                  DeliveryAddressSelector(
                    currentAddress: _deliveryAddress,
                    estimatedTime: _estimatedDeliveryTime,
                    onChangeAddress: _changeAddress,
                  ),
                  SizedBox(height: 2.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return CartItemCard(
                        item: item,
                        onRemove: () => _removeItem(item['id'] as int),
                        onQuantityChanged: (quantity) =>
                            _updateQuantity(item['id'] as int, quantity),
                        onMoveToFavorites: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Item moved to favorites')),
                          );
                        },
                        onEditCustomizations: () {
                          Navigator.pushNamed(
                              context, '/restaurant-detail-screen');
                        },
                        onReorder: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Item added to cart again')),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 2.h),
                  PromoCodeInput(
                    onPromoApplied: _applyPromoCode,
                    currentPromoCode:
                        _currentPromoCode.isNotEmpty ? _currentPromoCode : null,
                    isLoading: _isPromoLoading,
                  ),
                  SizedBox(height: 2.h),
                  OrderSummaryCard(
                    subtotal: _subtotal,
                    deliveryFee: _deliveryFee,
                    taxes: _taxes,
                    total: _total,
                    promoCode:
                        _currentPromoCode.isNotEmpty ? _currentPromoCode : null,
                    discount: _promoDiscount > 0 ? _promoDiscount : null,
                  ),
                  SizedBox(height: 10.h), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowSubtle,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${_total.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentYellow,
                  ),
                ),
                Text(
                  '${_cartItems.length} item${_cartItems.length != 1 ? 's' : ''}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentYellow,
                  foregroundColor: AppTheme.primaryBlack,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryBlack),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'payment',
                            color: AppTheme.primaryBlack,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Proceed to Checkout',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
