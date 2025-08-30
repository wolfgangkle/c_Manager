import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../sync/certificate.dart';

class CertificateForm extends StatefulWidget {
  final Certificate? initialData;
  final Function(Certificate) onSave;

  const CertificateForm({this.initialData, required this.onSave, super.key});

  @override
  State<CertificateForm> createState() => _CertificateFormState();
}

class _CertificateFormState extends State<CertificateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _issuerController;
  DateTime? _expirationDate;
  bool _notificationsEnabled = false;
  String? _filePath; // simulate a file picker if needed
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?.title ?? '');
    _issuerController = TextEditingController(text: widget.initialData?.issuer ?? '');
    _expirationDate = widget.initialData?.expiry;
    _notificationsEnabled = widget.initialData?.notifications ?? false;
    _filePath = widget.initialData?.filePath ?? '';
    _selectedTags = widget.initialData?.tags ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _issuerController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _expirationDate != null) {
      final cert = Certificate(
        title: _titleController.text,
        expiry: _expirationDate!,
        filePath: _filePath ?? '',
        tags: _selectedTags,
        notifications: _notificationsEnabled,
        issuer: _issuerController.text,
      );
      widget.onSave(cert);
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _issuerController,
            decoration: const InputDecoration(labelText: 'Issuer'),
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                _expirationDate != null
                    ? 'Expires: ${DateFormat.yMd().format(_expirationDate!)}'
                    : 'No date selected',
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _pickDate,
                child: const Text('Pick Date'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            title: const Text('Enable Notifications'),
          ),
          const SizedBox(height: 10),
          // Simple file path field (replace with file picker later)
          TextFormField(
            initialValue: _filePath,
            decoration: const InputDecoration(labelText: 'File Path'),
            onChanged: (val) => _filePath = val,
          ),
          const SizedBox(height: 10),
          // Simple tag field for now
          TextFormField(
            initialValue: _selectedTags.join(', '),
            decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
            onChanged: (val) => _selectedTags = val.split(',').map((e) => e.trim()).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
