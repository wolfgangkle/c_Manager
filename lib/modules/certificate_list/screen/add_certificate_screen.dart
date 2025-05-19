import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:c_manager/modules/sync/certificate.dart';

class AddCertificateScreen extends StatefulWidget {
  const AddCertificateScreen({super.key});

  @override
  State<AddCertificateScreen> createState() => _AddCertificateScreenState();
}

class _AddCertificateScreenState extends State<AddCertificateScreen> {
  final _nameController = TextEditingController();
  DateTime? _expirationDate;
  bool _notificationsEnabled = false;
  File? _imageFile;

  final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  int get _remainingDays {
    if (_expirationDate == null) return 0;
    return _expirationDate!.difference(DateTime.now()).inDays;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _expirationDate = picked);
    }
  }

  void _save() async {
    if (_nameController.text.isNotEmpty && _expirationDate != null) {
      final box = Hive.box<Certificate>('certificates');

      final cert = Certificate(
        title: _nameController.text,
        expiry: _expirationDate!,
        filePath: _imageFile?.path ?? '',
        tags: ['General'], // You can change this
        notifications: _notificationsEnabled,
      );

      await box.add(cert);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Certificate'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_imageFile != null)
            Image.file(_imageFile!, height: 220, fit: BoxFit.contain)
          else
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 220,
                color: Colors.grey[300],
                child: const Center(
                  child: Text('Tap to add certificate image'),
                ),
              ),
            ),
          const SizedBox(height: 24),
          const Text('CERTIFICATE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 4),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter certificate name',
              filled: true,
              fillColor: Colors.black12,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 24),
          const Text('REMAINING DAYS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black12,
            child: Text(
              _expirationDate == null
                  ? 'Not set'
                  : (_remainingDays < 0 ? 'Expired' : '$_remainingDays days'),
              style: TextStyle(
                fontSize: 16,
                color: _remainingDays < 0 ? Colors.red : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('EXPIRATION', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black12,
              child: Text(
                _expirationDate == null
                    ? 'Tap to select a date'
                    : _dateFormat.format(_expirationDate!),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('REMINDER', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 4),
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            title: Text(
              'Notifications: ${_notificationsEnabled ? "On" : "Off"}',
              style: TextStyle(
                color: _notificationsEnabled ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
