import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChanged;
  final VoidCallback? onMoveToFavorites;
  final VoidCallback? onEditCustomizations;
  final VoidCallback? onReorder;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
    this.onMoveToFavorites,
    this.onEditCustomizations,
    this.onReorder,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _showDeleteConfirmation = false;
  int _currentQuantity = 1;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.item['quantity'] ?? 1;

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _handleQuantityChange(int delta) {
    setState(() {
      _currentQuantity = (_currentQuantity + delta).clamp(1, 99);
    });
    widget.onQuantityChanged(_currentQuantity);

    // Haptic feedback on iOS
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      HapticFeedback.lightImpact();
    }
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'favorite_border',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text(
                  'Move to Favorites',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onMoveToFavorites?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text(
                  'Edit Customizations',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onEditCustomizations?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
                title: Text(
                  'Reorder',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onReorder?.call();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSwipeToDelete() {
    if (_slideController.value > 0.5) {
      setState(() {
        _showDeleteConfirmation = true;
      });
      _slideController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: _showDeleteConfirmation
          ? _buildDeleteConfirmation()
          : _buildCartItem(),
    );
  }

  Widget _buildDeleteConfirmation() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'warning',
            color: AppTheme.errorRed,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remove item?',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.errorRed,
                  ),
                ),
                Text(
                  'This action cannot be undone',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _showDeleteConfirmation = false;
              });
            },
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge,
            ),
          ),
          SizedBox(width: 2.w),
          ElevatedButton(
            onPressed: widget.onRemove,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.surfaceWhite,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem() {
    return GestureDetector(
      onLongPress: _showContextMenu,
      child: Dismissible(
        key: Key(widget.item['id'].toString()),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          _handleSwipeToDelete();
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.errorRed,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: 'delete',
            color: AppTheme.surfaceWhite,
            size: 24,
          ),
        ),
        child: Container(
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
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomImageWidget(
                  imageUrl: widget.item['image'] as String,
                  width: 20.w,
                  height: 20.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item['name'] as String,
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      widget.item['restaurant'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    if (widget.item['customizations'] != null) ...[
                      Text(
                        widget.item['customizations'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.infoBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.item['price'] as String,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.accentYellow,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _buildQuantityControls(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.neutralGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap:
                _currentQuantity > 1 ? () => _handleQuantityChange(-1) : null,
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'remove',
                color: _currentQuantity > 1
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.textSecondary,
                size: 18,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(minWidth: 10.w),
            alignment: Alignment.center,
            child: Text(
              _currentQuantity.toString(),
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap:
                _currentQuantity < 99 ? () => _handleQuantityChange(1) : null,
            child: Container(
              padding: EdgeInsets.all(2.w),
              child: CustomIconWidget(
                iconName: 'add',
                color: _currentQuantity < 99
                    ? AppTheme.lightTheme.colorScheme.onSurface
                    : AppTheme.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
