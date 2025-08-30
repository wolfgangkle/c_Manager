import 'package:flutter/material.dart';
import '../screen/certificate_form.dart';
import '../../sync/certificate.dart';
import 'package:hive/hive.dart';

class AddCertificateScreen extends StatelessWidget {
  const AddCertificateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Certificate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CertificateForm(
          onSave: (certificate) async {
            final box = await Hive.openBox<Certificate>('certificates');
            await box.add(certificate);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
