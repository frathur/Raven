import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/floating_cart_summary.dart';
import './widgets/menu_category_tabs.dart';
import './widgets/menu_item_card.dart';
import './widgets/menu_item_detail_modal.dart';
import './widgets/restaurant_hero_section.dart';
import './widgets/restaurant_info_expandable.dart';
import './widgets/restaurant_info_section.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  int selectedCategoryIndex = 0;
  bool isFavoriteRestaurant = false;
  Map<String, bool> favoriteItems = {};
  Map<String, int> cartItems = {};
  bool isLoading = false;

  final List<String> categories = [
    'Popular',
    'Appetizers',
    'Mains',
    'Desserts',
    'Beverages'
  ];

  // Mock restaurant data
  final Map<String, dynamic> restaurantData = {
    "id": "rest_001",
    "name": "Bella Vista Italian Kitchen",
    "description":
        "Authentic Italian cuisine with fresh ingredients and traditional recipes passed down through generations.",
    "heroImage":
        "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
    "logo":
        "https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80",
    "rating": 4.8,
    "deliveryTime": "25-35",
    "deliveryFee": "Free delivery",
    "cuisineTags": ["Italian", "Pizza", "Pasta", "Mediterranean"],
    "hours": "Mon-Sun: 11:00 AM - 11:00 PM",
    "phone": "+1 (555) 123-4567",
    "address": "123 Main Street, Downtown, NY 10001",
  };

  // Mock menu data organized by categories
  final Map<String, List<Map<String, dynamic>>> menuData = {
    "Popular": [
      {
        "id": "item_001",
        "name": "Margherita Pizza",
        "description":
            "Classic pizza with fresh mozzarella, tomato sauce, and basil",
        "fullDescription":
            "Our signature Margherita pizza features hand-tossed dough topped with San Marzano tomato sauce, fresh mozzarella di bufala, and aromatic basil leaves. Baked in our wood-fired oven for the perfect crispy crust.",
        "price": "\$18.99",
        "image":
            "https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.9,
        "reviewCount": 127,
        "isVegetarian": true,
        "sizes": [
          {"name": "Small", "price": "\$14.99"},
          {"name": "Medium", "price": "\$18.99"},
          {"name": "Large", "price": "\$22.99"}
        ],
        "customizations": [
          {"name": "Extra Cheese", "price": "\$2.00"},
          {"name": "Extra Basil", "price": "\$1.00"},
          {"name": "Gluten-Free Crust", "price": "\$3.00"}
        ],
        "nutrition": {"calories": 280, "protein": 12, "carbs": 35, "fat": 10}
      },
      {
        "id": "item_002",
        "name": "Spaghetti Carbonara",
        "description": "Creamy pasta with pancetta, eggs, and parmesan cheese",
        "fullDescription":
            "Traditional Roman carbonara made with al dente spaghetti, crispy pancetta, farm-fresh eggs, and aged Parmigiano-Reggiano. No cream, just authentic Italian technique.",
        "price": "\$16.99",
        "image":
            "https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.7,
        "reviewCount": 89,
        "isVegetarian": false,
        "customizations": [
          {"name": "Extra Pancetta", "price": "\$3.00"},
          {"name": "Extra Parmesan", "price": "\$2.00"}
        ],
        "nutrition": {"calories": 420, "protein": 18, "carbs": 45, "fat": 18}
      },
      {
        "id": "item_003",
        "name": "Chicken Parmigiana",
        "description":
            "Breaded chicken breast with marinara sauce and melted mozzarella",
        "fullDescription":
            "Tender chicken breast, lightly breaded and pan-fried to golden perfection, topped with our house-made marinara sauce and melted mozzarella cheese. Served with a side of spaghetti.",
        "price": "\$22.99",
        "image":
            "https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.6,
        "reviewCount": 156,
        "isVegetarian": false,
        "nutrition": {"calories": 580, "protein": 35, "carbs": 42, "fat": 28}
      }
    ],
    "Appetizers": [
      {
        "id": "item_004",
        "name": "Bruschetta Trio",
        "description": "Three varieties of toasted bread with fresh toppings",
        "fullDescription":
            "A selection of three bruschetta: classic tomato and basil, ricotta and honey, and mushroom and truffle oil. Served on toasted artisan bread.",
        "price": "\$12.99",
        "image":
            "https://images.unsplash.com/photo-1572441713132-51c75654db73?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.5,
        "reviewCount": 73,
        "isVegetarian": true,
        "nutrition": {"calories": 220, "protein": 8, "carbs": 28, "fat": 9}
      },
      {
        "id": "item_005",
        "name": "Antipasto Platter",
        "description":
            "Selection of cured meats, cheeses, and marinated vegetables",
        "fullDescription":
            "A generous platter featuring prosciutto di Parma, salami, fresh mozzarella, aged provolone, marinated olives, roasted peppers, and artichoke hearts.",
        "price": "\$19.99",
        "image":
            "https://images.unsplash.com/photo-1544025162-d76694265947?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.8,
        "reviewCount": 92,
        "isVegetarian": false,
        "nutrition": {"calories": 380, "protein": 22, "carbs": 15, "fat": 28}
      }
    ],
    "Mains": [
      {
        "id": "item_006",
        "name": "Osso Buco",
        "description": "Braised veal shanks with saffron risotto",
        "fullDescription":
            "Slow-braised veal shanks in a rich tomato and wine sauce, served with creamy saffron risotto and gremolata. A true Italian comfort food classic.",
        "price": "\$32.99",
        "image":
            "https://images.unsplash.com/photo-1546833999-b9f581a1996d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.9,
        "reviewCount": 45,
        "isVegetarian": false,
        "nutrition": {"calories": 650, "protein": 42, "carbs": 38, "fat": 32}
      },
      {
        "id": "item_007",
        "name": "Seafood Linguine",
        "description": "Fresh linguine with mixed seafood in white wine sauce",
        "fullDescription":
            "House-made linguine tossed with fresh mussels, clams, shrimp, and calamari in a delicate white wine and garlic sauce with fresh herbs.",
        "price": "\$28.99",
        "image":
            "https://images.unsplash.com/photo-1563379091339-03246963d96c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.7,
        "reviewCount": 68,
        "isVegetarian": false,
        "nutrition": {"calories": 520, "protein": 28, "carbs": 48, "fat": 22}
      }
    ],
    "Desserts": [
      {
        "id": "item_008",
        "name": "Tiramisu",
        "description": "Classic Italian dessert with coffee-soaked ladyfingers",
        "fullDescription":
            "Traditional tiramisu made with espresso-soaked ladyfingers, mascarpone cream, and dusted with cocoa powder. Made fresh daily in our kitchen.",
        "price": "\$8.99",
        "image":
            "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.8,
        "reviewCount": 134,
        "isVegetarian": true,
        "nutrition": {"calories": 320, "protein": 6, "carbs": 28, "fat": 20}
      },
      {
        "id": "item_009",
        "name": "Cannoli Siciliani",
        "description": "Crispy shells filled with sweet ricotta cream",
        "fullDescription":
            "Traditional Sicilian cannoli with crispy pastry shells filled with sweetened ricotta, chocolate chips, and candied orange peel. Dusted with powdered sugar.",
        "price": "\$7.99",
        "image":
            "https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.6,
        "reviewCount": 87,
        "isVegetarian": true,
        "nutrition": {"calories": 280, "protein": 8, "carbs": 32, "fat": 14}
      }
    ],
    "Beverages": [
      {
        "id": "item_010",
        "name": "Italian Soda Selection",
        "description": "Aranciata, Limonata, or Chinotto",
        "fullDescription":
            "Authentic Italian sodas imported directly from Italy. Choose from refreshing Aranciata (orange), zesty Limonata (lemon), or bitter-sweet Chinotto.",
        "price": "\$3.99",
        "image":
            "https://images.unsplash.com/photo-1544145945-f90425340c7e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.3,
        "reviewCount": 52,
        "isVegetarian": true,
        "nutrition": {"calories": 140, "protein": 0, "carbs": 36, "fat": 0}
      },
      {
        "id": "item_011",
        "name": "Espresso",
        "description": "Traditional Italian espresso",
        "fullDescription":
            "Rich, full-bodied espresso made from our signature Italian roast blend. Served in traditional espresso cups with a perfect crema.",
        "price": "\$2.99",
        "image":
            "https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=80",
        "rating": 4.7,
        "reviewCount": 98,
        "isVegetarian": true,
        "nutrition": {"calories": 5, "protein": 0, "carbs": 1, "fat": 0}
      }
    ]
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: categories.length, vsync: this);

    // Initialize favorite items
    for (final category in menuData.values) {
      for (final item in category) {
        favoriteItems[item["id"] as String] = false;
        cartItems[item["id"] as String] = 0;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.accentYellow,
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Custom app bar
                SliverAppBar(
                  expandedHeight: 35.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.surfaceWhite,
                  foregroundColor: AppTheme.primaryBlack,
                  elevation: 0,
                  leading: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back_ios',
                        color: AppTheme.primaryBlack,
                        size: 5.w,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'share',
                          color: AppTheme.primaryBlack,
                          size: 5.w,
                        ),
                      ),
                      onPressed: _shareRestaurant,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: RestaurantHeroSection(
                      restaurant: restaurantData,
                      isFavorite: isFavoriteRestaurant,
                      onFavoriteToggle: () => setState(
                          () => isFavoriteRestaurant = !isFavoriteRestaurant),
                    ),
                  ),
                ),

                // Restaurant info
                SliverToBoxAdapter(
                  child: RestaurantInfoSection(restaurant: restaurantData),
                ),

                // Sticky category tabs
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyTabBarDelegate(
                    child: MenuCategoryTabs(
                      categories: categories,
                      selectedIndex: selectedCategoryIndex,
                      onCategorySelected: (index) {
                        setState(() => selectedCategoryIndex = index);
                        _tabController.animateTo(index);
                      },
                    ),
                  ),
                ),

                // Menu items
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: categories.map((category) {
                      final items = menuData[category] ?? [];
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 2.h, bottom: 15.h),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final itemId = item["id"] as String;
                          return MenuItemCard(
                            menuItem: item,
                            isFavorite: favoriteItems[itemId] ?? false,
                            quantity: cartItems[itemId] ?? 0,
                            onTap: () => _showItemDetail(item),
                            onAddToCart: () => _addToCart(itemId),
                            onFavoriteToggle: () => _toggleFavorite(itemId),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                // Restaurant info expandable
                SliverToBoxAdapter(
                  child: RestaurantInfoExpandable(restaurant: restaurantData),
                ),
              ],
            ),

            // Floating cart summary
            FloatingCartSummary(
              itemCount: _getTotalItemCount(),
              totalAmount: _getTotalAmount(),
              onTap: () =>
                  Navigator.pushNamed(context, '/shopping-cart-screen'),
            ),

            // Loading overlay
            if (isLoading)
              Container(
                color: AppTheme.primaryBlack.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.accentYellow),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() => isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => isLoading = false);
  }

  void _shareRestaurant() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Restaurant shared successfully!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor: AppTheme.primaryBlack,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showItemDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MenuItemDetailModal(
        menuItem: item,
        onAddToCart: () => _addToCart(item["id"] as String),
      ),
    );
  }

  void _addToCart(String itemId) {
    setState(() {
      cartItems[itemId] = (cartItems[itemId] ?? 0) + 1;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Item added to cart!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _toggleFavorite(String itemId) {
    setState(() {
      favoriteItems[itemId] = !(favoriteItems[itemId] ?? false);
    });

    final isFavorite = favoriteItems[itemId] ?? false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite ? 'Added to favorites!' : 'Removed from favorites!',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.surfaceWhite,
          ),
        ),
        backgroundColor:
            isFavorite ? AppTheme.errorRed : AppTheme.textSecondary,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  int _getTotalItemCount() {
    return cartItems.values.fold(0, (sum, quantity) => sum + quantity);
  }

  String _getTotalAmount() {
    double total = 0.0;

    for (final category in menuData.values) {
      for (final item in category) {
        final itemId = item["id"] as String;
        final quantity = cartItems[itemId] ?? 0;
        if (quantity > 0) {
          final price =
              double.parse(item["price"].toString().replaceAll('\$', ''));
          total += price * quantity;
        }
      }
    }

    return '\$${total.toStringAsFixed(2)}';
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 6.h;

  @override
  double get maxExtent => 6.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
