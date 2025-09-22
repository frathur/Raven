import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PromoCodeInput extends StatefulWidget {
  final Function(String) onPromoApplied;
  final String? currentPromoCode;
  final bool isLoading;

  const PromoCodeInput({
    super.key,
    required this.onPromoApplied,
    this.currentPromoCode,
    this.isLoading = false,
  });

  @override
  State<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final TextEditingController _promoController = TextEditingController();
  final FocusNode _promoFocusNode = FocusNode();
  String? _validationMessage;
  bool _isValidCode = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentPromoCode != null) {
      _promoController.text = widget.currentPromoCode!;
      _isValidCode = true;
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    _promoFocusNode.dispose();
    super.dispose();
  }

  void _validateAndApplyPromo() {
    final promoCode = _promoController.text.trim().toUpperCase();

    if (promoCode.isEmpty) {
      setState(() {
        _validationMessage = 'Please enter a promo code';
        _isValidCode = false;
      });
      return;
    }

    // Mock validation - in real app, this would be an API call
    final validPromoCodes = ['SAVE10', 'WELCOME20', 'DRONE15', 'FIRST25'];

    if (validPromoCodes.contains(promoCode)) {
      setState(() {
        _validationMessage = 'Promo code applied successfully!';
        _isValidCode = true;
      });
      widget.onPromoApplied(promoCode);
      _promoFocusNode.unfocus();
    } else {
      setState(() {
        _validationMessage = 'Invalid promo code. Please try again.';
        _isValidCode = false;
      });
    }
  }

  void _removePromoCode() {
    setState(() {
      _promoController.clear();
      _validationMessage = null;
      _isValidCode = false;
    });
    widget.onPromoApplied('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowSubtle,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_offer',
                color: AppTheme.accentYellow,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Promo Code',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _promoController,
                  focusNode: _promoFocusNode,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'confirmation_number',
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _isValidCode
                        ? GestureDetector(
                            onTap: _removePromoCode,
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme.textSecondary,
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppTheme.neutralGray,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  onChanged: (value) {
                    if (_validationMessage != null) {
                      setState(() {
                        _validationMessage = null;
                      });
                    }
                  },
                  onFieldSubmitted: (_) => _validateAndApplyPromo(),
                ),
              ),
              SizedBox(width: 3.w),
              ElevatedButton(
                onPressed: widget.isLoading ? null : _validateAndApplyPromo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isValidCode
                      ? AppTheme.successGreen
                      : AppTheme.accentYellow,
                  foregroundColor: AppTheme.primaryBlack,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryBlack),
                        ),
                      )
                    : Text(
                        _isValidCode ? 'Applied' : 'Apply',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
          if (_validationMessage != null) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: _isValidCode ? 'check_circle' : 'error',
                  color:
                      _isValidCode ? AppTheme.successGreen : AppTheme.errorRed,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _validationMessage!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _isValidCode
                          ? AppTheme.successGreen
                          : AppTheme.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (_isValidCode) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'savings',
                    color: AppTheme.successGreen,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'You\'re saving money with this promo code!',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
