import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_results_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  List<String> _recentSearches = [
    'Pizza',
    'Sushi',
    'Burger',
    'Thai Food',
    'Italian'
  ];

  List<String> _searchSuggestions = [];
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _activeFilters = [];
  Map<String, dynamic> _currentFilters = {
    'cuisines': <String>[],
    'priceRange': null,
    'deliveryTime': null,
    'minRating': 0.0,
    'dietary': <String>[],
  };

  bool _isLoading = false;
  bool _isRecording = false;
  String _currentSearchQuery = '';

  // Mock data for restaurants
  final List<Map<String, dynamic>> _allRestaurants = [
    {
      'id': 1,
      'name': 'Mario\'s Italian Kitchen',
      'image':
          'https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg',
      'rating': 4.5,
      'deliveryTime': 25,
      'cuisine': 'Italian',
      'priceRange': '\$\$',
      'dietary': ['Vegetarian'],
      'menuItems': ['Margherita Pizza', 'Pasta Carbonara', 'Tiramisu'],
      'matchingItems': [],
    },
    {
      'id': 2,
      'name': 'Tokyo Sushi Bar',
      'image':
          'https://images.pexels.com/photos/357756/pexels-photo-357756.jpeg',
      'rating': 4.8,
      'deliveryTime': 30,
      'cuisine': 'Japanese',
      'priceRange': '\$\$\$',
      'dietary': ['Gluten-Free'],
      'menuItems': ['California Roll', 'Salmon Sashimi', 'Miso Soup'],
      'matchingItems': [],
    },
    {
      'id': 3,
      'name': 'Burger Palace',
      'image':
          'https://images.pexels.com/photos/1639557/pexels-photo-1639557.jpeg',
      'rating': 4.2,
      'deliveryTime': 20,
      'cuisine': 'American',
      'priceRange': '\$\$',
      'dietary': [],
      'menuItems': ['Classic Burger', 'Chicken Wings', 'Milkshake'],
      'matchingItems': [],
    },
    {
      'id': 4,
      'name': 'Spice Garden',
      'image':
          'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
      'rating': 4.6,
      'deliveryTime': 35,
      'cuisine': 'Indian',
      'priceRange': '\$\$',
      'dietary': ['Vegetarian', 'Vegan', 'Halal'],
      'menuItems': ['Butter Chicken', 'Biryani', 'Naan Bread'],
      'matchingItems': [],
    },
    {
      'id': 5,
      'name': 'Mediterranean Delight',
      'image':
          'https://images.pexels.com/photos/1640772/pexels-photo-1640772.jpeg',
      'rating': 4.4,
      'deliveryTime': 28,
      'cuisine': 'Mediterranean',
      'priceRange': '\$\$\$',
      'dietary': ['Vegetarian', 'Gluten-Free'],
      'menuItems': ['Greek Salad', 'Hummus Platter', 'Grilled Lamb'],
      'matchingItems': [],
    },
    {
      'id': 6,
      'name': 'Thai Basil',
      'image':
          'https://images.pexels.com/photos/1640773/pexels-photo-1640773.jpeg',
      'rating': 4.3,
      'deliveryTime': 32,
      'cuisine': 'Thai',
      'priceRange': '\$\$',
      'dietary': ['Vegan'],
      'menuItems': ['Pad Thai', 'Green Curry', 'Tom Yum Soup'],
      'matchingItems': [],
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateSearchSuggestions('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Search',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'tune',
                  color: AppTheme.primaryBlack,
                  size: 24,
                ),
                if (_activeFilters.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentYellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
            onVoicePressed: _onVoicePressed,
            onClearPressed: _onClearPressed,
            suggestions: _searchSuggestions,
            onSuggestionTapped: _onSuggestionTapped,
          ),
          FilterChipsWidget(
            activeFilters: _activeFilters,
            onFilterRemoved: _onFilterRemoved,
            onClearAll: _onClearAllFilters,
          ),
          if (_currentSearchQuery.isEmpty && _searchResults.isEmpty)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RecentSearchesWidget(
                      recentSearches: _recentSearches,
                      onSearchTapped: _onRecentSearchTapped,
                      onSearchRemoved: _onRecentSearchRemoved,
                    ),
                    SizedBox(height: 4.h),
                    _buildTrendingSearches(),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: SearchResultsWidget(
                searchResults: _searchResults,
                searchQuery: _currentSearchQuery,
                onRestaurantTapped: _onRestaurantTapped,
                onRefresh: _onRefresh,
                isLoading: _isLoading,
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.contextual(
        context: context,
        currentIndex: 1,
      ),
    );
  }

  Widget _buildTrendingSearches() {
    final trendingSearches = ['Pizza', 'Sushi', 'Burger', 'Pasta', 'Tacos'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Searches',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trendingSearches.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.neutralGray,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final search = trendingSearches[index];
              return ListTile(
                leading: CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.accentYellow,
                  size: 20,
                ),
                title: Text(
                  search,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                trailing: CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
                onTap: () => _onTrendingSearchTapped(search),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentSearchQuery = query;
    });
    _updateSearchSuggestions(query);
    if (query.isNotEmpty) {
      _performSearch(query);
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      _addToRecentSearches(query);
      _performSearch(query);
    }
  }

  void _onClearPressed() {
    setState(() {
      _currentSearchQuery = '';
      _searchResults = [];
    });
    _updateSearchSuggestions('');
  }

  void _onSuggestionTapped(String suggestion) {
    _searchController.text = suggestion;
    _addToRecentSearches(suggestion);
    _performSearch(suggestion);
  }

  void _onRecentSearchTapped(String search) {
    _searchController.text = search;
    setState(() {
      _currentSearchQuery = search;
    });
    _performSearch(search);
  }

  void _onRecentSearchRemoved(String search) {
    setState(() {
      _recentSearches.remove(search);
    });
  }

  void _onTrendingSearchTapped(String search) {
    _searchController.text = search;
    setState(() {
      _currentSearchQuery = search;
    });
    _addToRecentSearches(search);
    _performSearch(search);
  }

  void _onRestaurantTapped(Map<String, dynamic> restaurant) {
    Navigator.pushNamed(
      context,
      '/restaurant-detail-screen',
      arguments: {
        'restaurant': restaurant,
        'searchQuery': _currentSearchQuery,
      },
    );
  }

  void _onRefresh() {
    if (_currentSearchQuery.isNotEmpty) {
      _performSearch(_currentSearchQuery);
    }
  }

  void _onFilterRemoved(String filter) {
    setState(() {
      _activeFilters.remove(filter);
    });
    _updateFiltersFromActiveList();
    if (_currentSearchQuery.isNotEmpty) {
      _performSearch(_currentSearchQuery);
    }
  }

  void _onClearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _currentFilters = {
        'cuisines': <String>[],
        'priceRange': null,
        'deliveryTime': null,
        'minRating': 0.0,
        'dietary': <String>[],
      };
    });
    if (_currentSearchQuery.isNotEmpty) {
      _performSearch(_currentSearchQuery);
    }
  }

  Future<void> _onVoicePressed() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_search.m4a');

        // Simulate voice recognition after 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        await _stopRecording();
      } else {
        // Handle permission denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice search'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice search is not available'),
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        // Simulate voice recognition result
        const voiceResult = 'pizza';
        _searchController.text = voiceResult;
        setState(() {
          _currentSearchQuery = voiceResult;
        });
        _addToRecentSearches(voiceResult);
        _performSearch(voiceResult);
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: _onFiltersApplied,
      ),
    );
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _activeFilters = _buildActiveFiltersList(filters);
    });
    if (_currentSearchQuery.isNotEmpty) {
      _performSearch(_currentSearchQuery);
    }
  }

  void _updateSearchSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
      });
      return;
    }

    final suggestions = <String>[];

    // Add matching restaurant names
    for (final restaurant in _allRestaurants) {
      final name = restaurant['name'] as String;
      if (name.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(name);
      }
    }

    // Add matching menu items
    for (final restaurant in _allRestaurants) {
      final menuItems = restaurant['menuItems'] as List<dynamic>;
      for (final item in menuItems) {
        final itemName = item as String;
        if (itemName.toLowerCase().contains(query.toLowerCase()) &&
            !suggestions.contains(itemName)) {
          suggestions.add(itemName);
        }
      }
    }

    setState(() {
      _searchSuggestions = suggestions.take(5).toList();
    });
  }

  void _performSearch(String query) {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final results = <Map<String, dynamic>>[];

      for (final restaurant in _allRestaurants) {
        final restaurantCopy = Map<String, dynamic>.from(restaurant);
        final matchingItems = <String>[];

        // Check if restaurant name matches
        final name = restaurant['name'] as String;
        bool nameMatches = name.toLowerCase().contains(query.toLowerCase());

        // Check if any menu items match
        final menuItems = restaurant['menuItems'] as List<dynamic>;
        for (final item in menuItems) {
          final itemName = item as String;
          if (itemName.toLowerCase().contains(query.toLowerCase())) {
            matchingItems.add(itemName);
          }
        }

        // Apply filters
        if (_shouldIncludeRestaurant(restaurant, _currentFilters)) {
          if (nameMatches || matchingItems.isNotEmpty) {
            restaurantCopy['matchingItems'] = matchingItems;
            results.add(restaurantCopy);
          }
        }
      }

      // Sort by relevance (name matches first, then by rating)
      results.sort((a, b) {
        final aNameMatch =
            (a['name'] as String).toLowerCase().contains(query.toLowerCase());
        final bNameMatch =
            (b['name'] as String).toLowerCase().contains(query.toLowerCase());

        if (aNameMatch && !bNameMatch) return -1;
        if (!aNameMatch && bNameMatch) return 1;

        return (b['rating'] as double).compareTo(a['rating'] as double);
      });

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    });
  }

  bool _shouldIncludeRestaurant(
      Map<String, dynamic> restaurant, Map<String, dynamic> filters) {
    // Check cuisine filter
    final selectedCuisines = filters['cuisines'] as List<String>;
    if (selectedCuisines.isNotEmpty) {
      final restaurantCuisine = restaurant['cuisine'] as String;
      if (!selectedCuisines.contains(restaurantCuisine)) {
        return false;
      }
    }

    // Check price range filter
    final selectedPriceRange = filters['priceRange'] as String?;
    if (selectedPriceRange != null) {
      final restaurantPriceRange = restaurant['priceRange'] as String;
      if (restaurantPriceRange != selectedPriceRange) {
        return false;
      }
    }

    // Check delivery time filter
    final selectedDeliveryTime = filters['deliveryTime'] as String?;
    if (selectedDeliveryTime != null) {
      final restaurantDeliveryTime = restaurant['deliveryTime'] as int;
      final maxTime =
          int.tryParse(selectedDeliveryTime.replaceAll(RegExp(r'[^\d]'), '')) ??
              999;
      if (restaurantDeliveryTime > maxTime) {
        return false;
      }
    }

    // Check rating filter
    final minRating = filters['minRating'] as double;
    if (minRating > 0) {
      final restaurantRating = restaurant['rating'] as double;
      if (restaurantRating < minRating) {
        return false;
      }
    }

    // Check dietary preferences
    final selectedDietary = filters['dietary'] as List<String>;
    if (selectedDietary.isNotEmpty) {
      final restaurantDietary = restaurant['dietary'] as List<dynamic>;
      bool hasMatch = false;
      for (final dietary in selectedDietary) {
        if (restaurantDietary.contains(dietary)) {
          hasMatch = true;
          break;
        }
      }
      if (!hasMatch) {
        return false;
      }
    }

    return true;
  }

  void _addToRecentSearches(String search) {
    setState(() {
      _recentSearches.remove(search);
      _recentSearches.insert(0, search);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    });
  }

  List<String> _buildActiveFiltersList(Map<String, dynamic> filters) {
    final activeFilters = <String>[];

    final cuisines = filters['cuisines'] as List<String>;
    activeFilters.addAll(cuisines);

    final priceRange = filters['priceRange'] as String?;
    if (priceRange != null) {
      activeFilters.add(priceRange);
    }

    final deliveryTime = filters['deliveryTime'] as String?;
    if (deliveryTime != null) {
      activeFilters.add(deliveryTime);
    }

    final minRating = filters['minRating'] as double;
    if (minRating > 0) {
      activeFilters.add('${minRating.toStringAsFixed(1)}+ stars');
    }

    final dietary = filters['dietary'] as List<String>;
    activeFilters.addAll(dietary);

    return activeFilters;
  }

  void _updateFiltersFromActiveList() {
    // This method would reverse-engineer filters from active list
    // For simplicity, we'll clear all filters when individual ones are removed
    setState(() {
      _currentFilters = {
        'cuisines': <String>[],
        'priceRange': null,
        'deliveryTime': null,
        'minRating': 0.0,
        'dietary': <String>[],
      };
    });
  }
}
