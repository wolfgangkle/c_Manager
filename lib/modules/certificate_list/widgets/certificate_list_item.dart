import 'package:flutter/material.dart';
import '../../sync/certificate.dart';
import '../screen/edit_certificate_screen.dart';

class CertificateListItem extends StatelessWidget {
  final Certificate certificate;
  final dynamic certificateKey;
  final VoidCallback? onTap; // ✅ Added this line

  const CertificateListItem({
    super.key,
    required this.certificate,
    required this.certificateKey,
    this.onTap, // ✅ Allow optional tap callback
  });

  Color getBadgeColor(int days) {
    if (days <= 0) return Colors.red;
    if (days <= 90) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // ✅ Respond to taps if provided
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Edit + Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Expanded(
                  child: Text(
                    certificate.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCertificateScreen(
                          certificate: certificate,
                          certificateKey: certificateKey,
                        ),
                      ),
                    );
                  },
                ),

                // Days Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getBadgeColor(certificate.daysRemaining),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${certificate.daysRemaining} days",
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
              children: certificate.tags.map((tag) {
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
      ),
    );
  }
}
