import 'package:flutter/material.dart';

class CertificateListItem extends StatelessWidget {
  final String title;
  final List<String> tags;
  final int daysRemaining;

  const CertificateListItem({
    super.key,
    required this.title,
    required this.tags,
    required this.daysRemaining,
  });

  Color getBadgeColor(int days) {
    if (days <= 0) return Colors.red;
    if (days <= 90) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Days badge row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: 8),

              // Days badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: getBadgeColor(daysRemaining),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$daysRemaining days",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),

          const Divider(height: 20),
        ],
      ),
    );
  }
}
