import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_route_observer.dart';
import '../../routes/scaffold_with_bottom_nav.dart';
import '../cart/cart_screen.dart';
import '../categories/categories_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';
import 'controllers/app_shell_controller.dart';

class AppShellScreen extends StatefulWidget {
  const AppShellScreen({super.key, required this.initialIndex});

  final int initialIndex;

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen>
    with WidgetsBindingObserver, RouteAware {
  final List<bool> _visitedTabs = List<bool>.filled(5, false);
  PageRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _visitedTabs[widget.initialIndex] = true;
    // Defer initialization to post-frame so update() doesn't fire during build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.find<AppShellController>().initialize(widget.initialIndex);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      Get.find<AppShellController>().refreshCurrentTab();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && route != _route) {
      if (_route != null) {
        appRouteObserver.unsubscribe(this);
      }
      _route = route;
      appRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    if (mounted) {
      Get.find<AppShellController>().refreshCurrentTab();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppShellController>(
      builder: (controller) {
        final currentIndex = controller.currentIndex.clamp(0, 4);
        _visitedTabs[currentIndex] = true;

        return ScaffoldWithBottomNav(
          currentIndex: currentIndex,
          onTap: (index) {
            controller.setIndex(index);
          },
          child: IndexedStack(
            index: currentIndex,
            children: List.generate(5, (index) {
              if (!_visitedTabs[index]) {
                return const SizedBox.shrink();
              }
              return _KeepAliveTab(child: _buildTab(index));
            }),
          ),
        );
      },
    );
  }

  Widget _buildTab(int index) {
    return switch (index) {
      0 => const HomeScreen(),
      1 => const CategoriesScreen(),
      2 => const SearchScreen(),
      3 => const CartScreen(),
      4 => const ProfileScreen(),
      _ => const HomeScreen(),
    };
  }
}

class _KeepAliveTab extends StatefulWidget {
  const _KeepAliveTab({required this.child});

  final Widget child;

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
