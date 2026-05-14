import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'desktop_card.dart';

class DesktopDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;
  final Widget? footer;

  const DesktopDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return DesktopCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: columns.map((col) => Expanded(
                child: Text(
                  col.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLightSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              )).toList(),
            ),
          ),
          
          // Data Rows
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(48),
              child: Center(
                child: Text('No data available', style: TextStyle(color: AppColors.textLightSecondary)),
              ),
            )
          else
            ...rows.asMap().entries.map((entry) {
              final isLast = entry.key == rows.length - 1;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  border: isLast && footer == null ? null : const Border(bottom: BorderSide(color: AppColors.borderLight)),
                ),
                child: Row(
                  children: entry.value.map((cell) => Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 14, color: AppColors.textLightPrimary),
                      child: cell,
                    ),
                  )).toList(),
                ),
              );
            }),
            
          // Optional Footer (Pagination etc)
          if (footer != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: footer,
            ),
        ],
      ),
    );
  }
}
