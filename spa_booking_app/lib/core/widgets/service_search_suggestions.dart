import 'package:flutter/material.dart';

import '../../models/spa_service.dart';
import '../constants/app_colors.dart';

class ServiceSearchSuggestions extends StatelessWidget {
  const ServiceSearchSuggestions({
    super.key,
    required this.query,
    required this.services,
    required this.onSelected,
    this.maxResults = 5,
  });

  final String query;
  final List<SpaService> services;
  final ValueChanged<SpaService> onSelected;
  final int maxResults;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final suggestions = services.take(maxResults).toList(growable: false);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.soft,
      ),
      clipBehavior: Clip.antiAlias,
      child: suggestions.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.search_off_rounded, color: AppColors.textLight),
                  SizedBox(width: 10),
                  Expanded(child: Text('Không tìm thấy dịch vụ phù hợp')),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < suggestions.length; index++) ...[
                  _SuggestionTile(
                    service: suggestions[index],
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      onSelected(suggestions[index]);
                    },
                  ),
                  if (index < suggestions.length - 1)
                    const Divider(height: 1, indent: 52),
                ],
              ],
            ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.service, required this.onTap});

  final SpaService service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            const Icon(Icons.spa_rounded, color: AppColors.primary, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${service.category} • ${service.durationMinutes} phút',
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
