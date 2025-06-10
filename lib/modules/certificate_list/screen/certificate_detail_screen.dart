import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:c_manager/modules/sync/certificate.dart';
import 'package:c_manager/modules/certificate_list/screen/add_certificate_screen.dart';

class CertificateDetailScreen extends StatefulWidget {
  final Certificate certificate;
  final dynamic certificateKey; // Hive key

  const CertificateDetailScreen({
    super.key,
    required this.certificate,
    required this.certificateKey,
  });

  @override
  State<CertificateDetailScreen> createState() => _CertificateDetailScreenState();
}

class _CertificateDetailScreenState extends State<CertificateDetailScreen> {
  late Certificate _certificate;

  @override
  void initState() {
    super.initState();
    _certificate = widget.certificate;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy');
    final remainingDays = _certificate.expiry.difference(DateTime.now()).inDays;
    final isExpired = remainingDays < 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_certificate.title),
        actions: [
          IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Edit',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddCertificateScreen(
                    existingCertificate: widget.certificate,
                    certificateKey: widget.certificateKey,
                  ),
                ),
              );
              Navigator.pop(context); // Return to HomeScreen after editing
            },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_certificate.filePath.isNotEmpty && File(_certificate.filePath).existsSync())
            Image.file(File(_certificate.filePath), height: 260, fit: BoxFit.contain)
          else
            Container(
              height: 260,
              color: Colors.grey[300],
              child: const Center(child: Text('No file attached')),
            ),
          const SizedBox(height: 24),

          _buildLabel('CERTIFICATE'),
          _buildBox(_certificate.title),

          const SizedBox(height: 16),
          _buildLabel('REMAINING DAYS'),
          _buildBox(
            isExpired ? 'Expired' : '$remainingDays days',
            color: isExpired ? Colors.red : Colors.black,
          ),

          const SizedBox(height: 16),
          _buildLabel('EXPIRATION'),
          _buildBox(dateFormat.format(_certificate.expiry)),

          const SizedBox(height: 16),
          _buildLabel('REMINDER'),
          _buildBox(
            'Notifications: ${_certificate.notifications ? "On" : "Off"}',
            color: _certificate.notifications ? Colors.green : Colors.red,
          ),

          const SizedBox(height: 16),
          _buildLabel('TAGS'),
          _buildBox(_certificate.tags.join(', ')),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
  );

  Widget _buildBox(String text, {Color color = Colors.black}) => Container(
    padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.only(top: 4),
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 16, color: color),
    ),
  );
}
