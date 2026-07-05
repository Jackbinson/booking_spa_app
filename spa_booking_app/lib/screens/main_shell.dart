import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../models/spa_service.dart';
import '../providers/booking_provider.dart';
import 'appointments/appointments_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'services/service_detail_screen.dart';
import 'services/services_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  void _openServiceDetail(BuildContext context, SpaService service) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ServiceDetailScreen(service: service),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, _) {
        final pages = [
          HomeScreen(
            onOpenService: (service) => _openServiceDetail(context, service),
          ),
          ServicesScreen(
            onOpenService: (service) => _openServiceDetail(context, service),
          ),
          const AppointmentsScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          body: SafeArea(child: pages[provider.currentTabIndex]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: provider.currentTabIndex,
            onDestinationSelected: provider.setCurrentTab,
            indicatorColor: AppColors.secondary,
            destinations: const [
              NavigationDestination(
                icon: _NavImageIcon(asset: AppAssets.navHome),
                selectedIcon: _NavImageIcon(
                  asset: AppAssets.navHome,
                  selected: true,
                ),
                label: 'Trang chá»§',
              ),
              NavigationDestination(
                icon: _NavImageIcon(asset: AppAssets.navService),
                selectedIcon: _NavImageIcon(
                  asset: AppAssets.navService,
                  selected: true,
                ),
                label: 'Dá»‹ch vá»¥',
              ),
              NavigationDestination(
                icon: _NavImageIcon(asset: AppAssets.navCalendar),
                selectedIcon: _NavImageIcon(
                  asset: AppAssets.navCalendar,
                  selected: true,
                ),
                label: 'Lá»‹ch háº¹n',
              ),
              NavigationDestination(
                icon: _NavImageIcon(asset: AppAssets.navProfile),
                selectedIcon: _NavImageIcon(
                  asset: AppAssets.navProfile,
                  selected: true,
                ),
                label: 'Há»“ sÆ¡',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavImageIcon extends StatelessWidget {
  const _NavImageIcon({required this.asset, this.selected = false});

  final String asset;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: selected ? 1 : .66,
      child: Image.asset(
        asset,
        width: selected ? 30 : 26,
        height: selected ? 30 : 26,
        fit: BoxFit.contain,
      ),
    );
  }
}
