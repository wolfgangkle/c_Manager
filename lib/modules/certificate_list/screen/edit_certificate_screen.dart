import 'package:flutter/material.dart';
import '../screen/certificate_form.dart';
import '../../sync/certificate.dart';
import 'package:hive/hive.dart';

class EditCertificateScreen extends StatelessWidget {
  final Certificate certificate;
  final dynamic certificateKey;

  const EditCertificateScreen({
    required this.certificate,
    required this.certificateKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Certificate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CertificateForm(
          initialData: certificate,
          onSave: (updatedCertificate) async {
            final box = await Hive.openBox<Certificate>('certificates');
            await box.put(certificateKey, updatedCertificate);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
