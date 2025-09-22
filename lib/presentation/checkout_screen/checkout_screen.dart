import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/checkout_progress_widget.dart';
import './widgets/delivery_address_widget.dart';
import './widgets/delivery_instructions_widget.dart';
import './widgets/order_summary_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/security_badges_widget.dart';
import './widgets/tip_selection_widget.dart';
import 'widgets/checkout_progress_widget.dart';
import 'widgets/delivery_address_widget.dart';
import 'widgets/delivery_instructions_widget.dart';
import 'widgets/order_summary_widget.dart';
import 'widgets/payment_method_widget.dart';
import 'widgets/security_badges_widget.dart';
import 'widgets/tip_selection_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 2; // Checkout step (0: Cart, 1: Address, 2: Payment)
  int _selectedPaymentIndex = 0;
  double _selectedTipPercentage = 0.0;
  double _customTipAmount = 0.0;
  bool _isProcessingPayment = false;

  final TextEditingController _deliveryInstructionsController =
      TextEditingController();
  final TextEditingController _customTipController = TextEditingController();

  // Mock data
  final List<String> _checkoutSteps = ['Cart', 'Address', 'Payment', 'Confirm'];

  final Map<String, dynamic> _deliveryAddress = {
    'type': 'Home',
    'street': '123 Main Street, Apt 4B',
    'city': 'New York',
    'state': 'NY',
    'zipCode': '10001',
  };

  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'name': 'Margherita Pizza',
      'price': 18.99,
      'quantity': 2,
      'image':
          'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400&h=400&fit=crop',
    },
    {
      'id': 2,
      'name': 'Caesar Salad',
      'price': 12.50,
      'quantity': 1,
      'image':
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=400&fit=crop',
    },
    {
      'id': 3,
      'name': 'Garlic Bread',
      'price': 6.99,
      'quantity': 1,
      'image':
          'https://images.unsplash.com/photo-1573140247632-f8fd74997d5c?w=400&h=400&fit=crop',
    },
    {
      'id': 4,
      'name': 'Chocolate Cake',
      'price': 8.99,
      'quantity': 1,
      'image':
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=400&fit=crop',
    },
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'type': 'credit_card',
      'name': 'Visa ending in 4242',
      'details': 'Expires 12/25',
    },
    {
      'type': 'apple_pay',
      'name': 'Apple Pay',
      'details': 'Touch ID or Face ID',
    },
    {
      'type': 'google_pay',
      'name': 'Google Pay',
      'details': 'Fingerprint or PIN',
    },
    {
      'type': 'paypal',
      'name': 'PayPal',
      'details': 'user@example.com',
    },
  ];

  double get _subtotal {
    return (_cartItems as List).fold(0.0, (sum, item) {
      final itemMap = item as Map<String, dynamic>;
      return sum +
          ((itemMap['price'] as double) * (itemMap['quantity'] as int));
    });
  }

  double get _deliveryFee => 3.99;
  double get _tax => _subtotal * 0.08;
  double get _tipAmount {
    if (_customTipAmount > 0) return _customTipAmount;
    return _subtotal * (_selectedTipPercentage / 100);
  }

  @override
  void dispose() {
    _deliveryInstructionsController.dispose();
    _customTipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress indicator
          CheckoutProgressWidget(
            currentStep: _currentStep,
            steps: _checkoutSteps,
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address
                  DeliveryAddressWidget(
                    address: _deliveryAddress,
                    onEditPressed: _handleEditAddress,
                  ),
                  SizedBox(height: 3.h),

                  // Order Summary
                  OrderSummaryWidget(
                    cartItems: _cartItems,
                    subtotal: _subtotal,
                    deliveryFee: _deliveryFee,
                    tax: _tax,
                    tip: _tipAmount,
                  ),
                  SizedBox(height: 3.h),

                  // Payment Method
                  PaymentMethodWidget(
                    paymentMethods: _paymentMethods,
                    selectedIndex: _selectedPaymentIndex,
                    onMethodSelected: (index) {
                      setState(() {
                        _selectedPaymentIndex = index;
                      });
                    },
                    onAddNewCard: _handleAddNewCard,
                  ),
                  SizedBox(height: 3.h),

                  // Tip Selection
                  TipSelectionWidget(
                    selectedTipPercentage: _selectedTipPercentage,
                    customTipAmount: _customTipAmount,
                    subtotal: _subtotal,
                    customTipController: _customTipController,
                    onTipPercentageChanged: (percentage) {
                      setState(() {
                        _selectedTipPercentage = percentage;
                        _customTipAmount = 0.0;
                        _customTipController.clear();
                      });
                    },
                    onCustomTipChanged: (amount) {
                      setState(() {
                        _customTipAmount = amount;
                        _selectedTipPercentage = 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 3.h),

                  // Delivery Instructions
                  DeliveryInstructionsWidget(
                    controller: _deliveryInstructionsController,
                  ),
                  SizedBox(height: 3.h),

                  // Security Badges
                  const SecurityBadgesWidget(),
                  SizedBox(height: 10.h), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
                    'Total',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${(_subtotal + _deliveryFee + _tax + _tipAmount).toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentYellow,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isProcessingPayment ? null : _handlePlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentYellow,
                    foregroundColor: AppTheme.primaryBlack,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessingPayment
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryBlack,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Processing...',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Place Order',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleEditAddress() {
    // Navigate to address editing screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Address editing feature coming soon',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor: AppTheme.primaryBlack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleAddNewCard() {
    // Navigate to add card screen or show bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.neutralGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Add New Payment Method',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'This feature will integrate with your device\'s secure payment system to add new cards safely.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePlaceOrder() async {
    setState(() {
      _isProcessingPayment = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      // Simulate biometric authentication for supported payment methods
      if (_selectedPaymentIndex == 1 || _selectedPaymentIndex == 2) {
        // Apple Pay or Google Pay - would trigger biometric authentication
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Success - navigate to tracking screen
      if (mounted) {
        // Celebration haptic feedback
        HapticFeedback.heavyImpact();

        Navigator.pushReplacementNamed(context, '/live-tracking-screen');

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.successGreen,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Order placed successfully!',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.surfaceWhite,
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.successGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle payment errors
      if (mounted) {
        HapticFeedback.heavyImpact();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error',
                  color: AppTheme.surfaceWhite,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Payment failed. Please try again or use a different payment method.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.surfaceWhite,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }
}