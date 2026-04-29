import 'package:ecommerce_app/core/routing/app_routes.dart';
import 'package:ecommerce_app/features/account/address_screen.dart';
import 'package:ecommerce_app/features/account/my_details_screen.dart';
import 'package:ecommerce_app/features/auth/login_screen.dart';
import 'package:ecommerce_app/features/auth/register_screen.dart';
import 'package:ecommerce_app/features/cart/cart_screen.dart';
import 'package:ecommerce_app/features/home/data/product_model.dart';
import 'package:ecommerce_app/features/home/product_details_screen.dart';
import 'package:ecommerce_app/features/main_layout/main_layout_screen.dart';
import 'package:ecommerce_app/features/onboarding/onboarding_screen.dart';
import 'package:ecommerce_app/features/orders/orders_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/features/cart/checkout_screen.dart';


import 'package:go_router/go_router.dart';


 GoRouter getRouter(SharedPreferences prefs) {
  
    // 1. Read the flags from the hard drive
    final bool hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    final String? savedToken = prefs.getString('auth_token');
    
    // // 2. Decide the starting screen logically
    String initialRoute;
    if (!hasSeenOnboarding) {
      initialRoute = AppRoutes.onboardingScreen; // Brand new user
    } else if (savedToken != null) {
      initialRoute = AppRoutes.mainLayoutScreen; // Returning logged-in user
    } else {
      initialRoute = AppRoutes.loginScreen; // Returning logged-out user
    }
    return GoRouter(
    initialLocation: initialRoute,
    routes: [
            GoRoute(
        path: AppRoutes.onboardingScreen,
        name: AppRoutes.onboardingScreen,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        name: AppRoutes.loginScreen,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerScreen,
        name: AppRoutes.registerScreen,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.mainLayoutScreen,
        name: AppRoutes.mainLayoutScreen,
        builder: (context, state) => const MainLayoutScreen(),
      ),
      GoRoute(path: AppRoutes.productDetailsScreen, name: AppRoutes.productDetailsScreen, builder: (context, state) {
    // 1. Cast the extra object back into a ProductModel
    final product = state.extra as ProductModel; 
    // 2. Pass it to the screen
    return ProductDetailsScreen(product: product); 
  },),
      GoRoute(path: AppRoutes.addressScreen, name: AppRoutes.addressScreen, builder: (context, state) =>  AddressScreen()),
      GoRoute(path: AppRoutes.cartScreen, name: AppRoutes.cartScreen, builder: (context, state) =>  CartScreen()),
      GoRoute(path: AppRoutes.checkoutScreen, name: AppRoutes.checkoutScreen, builder: (context, state) =>  CheckoutScreen()),
      GoRoute(
  path: AppRoutes.ordersScreen,
  name: AppRoutes.ordersScreen,
  builder: (context, state) => const OrdersScreen(),
),
      GoRoute(
  path: AppRoutes.myDetailsScreen,
  name: AppRoutes.myDetailsScreen,
  builder: (context, state) => const MyDetailsScreen(),
),
    ],
  );
}