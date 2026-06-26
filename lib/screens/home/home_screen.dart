import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/info_row.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/service_card.dart';
import '../../data/mock_services.dart';
import '../../data/mock_spa_data.dart';
import '../../data/mock_user.dart';
import '../../models/spa_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenService});

  final ValueChanged<SpaService> onOpenService;

  @override
  Widget build(BuildContext context) {
    final popularServices = mockServices
        .where((service) => service.isPopular)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào, Kiên',
                    style: AppTextStyles.title.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hôm nay bạn muốn thư giãn như thế nào?',
                    style: AppTextStyles.muted,
                  ),
                ],
              ),
            ),
            ClipOval(
              child: Image.network(
                mockUser.avatar,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 48,
                  height: 48,
                  color: AppColors.secondary,
                  child: const Icon(Icons.person, color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _SearchBar(),
        const SizedBox(height: 20),
        const _PromoBanner(),
        const SizedBox(height: 22),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: serviceCategories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return CategoryChip(
                label: serviceCategories[index],
                selected: index == 0,
                onTap: () {},
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Dịch vụ nổi bật'),
        const SizedBox(height: 12),
        SizedBox(
          height: 246,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: popularServices.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final service = popularServices[index];
              return ServiceCard(
                service: service,
                compact: true,
                onTap: () => onOpenService(service),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const _SpaInfoCard(),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: AppColors.textLight),
          SizedBox(width: 10),
          Text('Tìm dịch vụ spa', style: AppTextStyles.muted),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppColors.secondary, Color(0xFFFFF8FB)],
        ),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Ưu đãi tuần này',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Giảm 20% dịch vụ massage',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.spa, color: AppColors.primary, size: 72),
        ],
      ),
    );
  }
}

class _SpaInfoCard extends StatelessWidget {
  const _SpaInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.soft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lavender Spa', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Text(lavenderSpa.description, style: AppTextStyles.muted),
          const SizedBox(height: 16),
          InfoRow(
            icon: Icons.place_outlined,
            label: 'Địa chỉ',
            value: lavenderSpa.address,
          ),
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.schedule,
            label: 'Giờ mở cửa',
            value: lavenderSpa.openingHours,
          ),
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.call_outlined,
            label: 'Hotline',
            value: lavenderSpa.phone,
          ),
        ],
      ),
    );
  }
}
