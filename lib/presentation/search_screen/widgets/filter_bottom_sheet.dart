import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _cuisineTypes = [
    'Italian',
    'Asian',
    'Mexican',
    'American',
    'Indian',
    'Mediterranean',
    'Thai',
    'Chinese'
  ];

  final List<String> _priceRanges = ['\$', '\$\$', '\$\$\$', '\$\$\$\$'];

  final List<String> _deliveryTimes = ['15 min', '30 min', '45 min', '60+ min'];

  final List<String> _dietaryPreferences = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Halal',
    'Kosher'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCuisineSection(),
                  SizedBox(height: 3.h),
                  _buildPriceRangeSection(),
                  SizedBox(height: 3.h),
                  _buildDeliveryTimeSection(),
                  SizedBox(height: 3.h),
                  _buildRatingSection(),
                  SizedBox(height: 3.h),
                  _buildDietarySection(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.neutralGray,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filters',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuisineSection() {
    return _buildExpandableSection(
      title: 'Cuisine Type',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _cuisineTypes.map((cuisine) {
          final isSelected =
              (_filters['cuisines'] as List<String>? ?? []).contains(cuisine);
          return _buildFilterChip(
            label: cuisine,
            isSelected: isSelected,
            onTap: () => _toggleCuisine(cuisine),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return _buildExpandableSection(
      title: 'Price Range',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _priceRanges.map((price) {
          final isSelected = _filters['priceRange'] == price;
          return _buildFilterChip(
            label: price,
            isSelected: isSelected,
            onTap: () => _setPriceRange(price),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeliveryTimeSection() {
    return _buildExpandableSection(
      title: 'Delivery Time',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _deliveryTimes.map((time) {
          final isSelected = _filters['deliveryTime'] == time;
          return _buildFilterChip(
            label: time,
            isSelected: isSelected,
            onTap: () => _setDeliveryTime(time),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingSection() {
    return _buildExpandableSection(
      title: 'Minimum Rating',
      child: Column(
        children: [
          Slider(
            value: (_filters['minRating'] as double? ?? 0.0),
            min: 0.0,
            max: 5.0,
            divisions: 10,
            activeColor: AppTheme.accentYellow,
            inactiveColor: AppTheme.neutralGray,
            onChanged: (value) {
              setState(() {
                _filters['minRating'] = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.0',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                '${(_filters['minRating'] as double? ?? 0.0).toStringAsFixed(1)} stars',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '5.0',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDietarySection() {
    return _buildExpandableSection(
      title: 'Dietary Preferences',
      child: Wrap(
        spacing: 2.w,
        runSpacing: 1.h,
        children: _dietaryPreferences.map((preference) {
          final isSelected =
              (_filters['dietary'] as List<String>? ?? []).contains(preference);
          return _buildFilterChip(
            label: preference,
            isSelected: isSelected,
            onTap: () => _toggleDietary(preference),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        child,
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentYellow : AppTheme.neutralGray,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppTheme.accentYellow, width: 1)
              : null,
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: isSelected ? AppTheme.primaryBlack : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.neutralGray,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearAllFilters,
              child: const Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCuisine(String cuisine) {
    setState(() {
      final cuisines = (_filters['cuisines'] as List<String>?) ?? <String>[];
      if (cuisines.contains(cuisine)) {
        cuisines.remove(cuisine);
      } else {
        cuisines.add(cuisine);
      }
      _filters['cuisines'] = cuisines;
    });
  }

  void _setPriceRange(String price) {
    setState(() {
      _filters['priceRange'] = _filters['priceRange'] == price ? null : price;
    });
  }

  void _setDeliveryTime(String time) {
    setState(() {
      _filters['deliveryTime'] = _filters['deliveryTime'] == time ? null : time;
    });
  }

  void _toggleDietary(String preference) {
    setState(() {
      final dietary = (_filters['dietary'] as List<String>?) ?? <String>[];
      if (dietary.contains(preference)) {
        dietary.remove(preference);
      } else {
        dietary.add(preference);
      }
      _filters['dietary'] = dietary;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'cuisines': <String>[],
        'priceRange': null,
        'deliveryTime': null,
        'minRating': 0.0,
        'dietary': <String>[],
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
