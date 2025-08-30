import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../sync/certificate.dart'; // ✅ Fixed import path
import '../widgets/certificate_list_item.dart';
import '../widgets/empty_state_view.dart';
import 'add_certificate_screen.dart';
import 'certificate_detail_screen.dart';

class CertificateListScreen extends StatefulWidget {
  const CertificateListScreen({super.key});

  @override
  State<CertificateListScreen> createState() => _CertificateListScreenState();
}

class _CertificateListScreenState extends State<CertificateListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Box<Certificate> _certificateBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _certificateBox = await Hive.openBox<Certificate>('certificates');
    setState(() {});
  }

  List<MapEntry<dynamic, Certificate>> get _filteredCertificates {
    final all = _certificateBox.toMap().entries.toList();

    if (_searchQuery.isEmpty) return all;

    return all.where((entry) {
      final cert = entry.value;
      final title = cert.title.toLowerCase();
      final tags = cert.tags.join(' ').toLowerCase();
      return title.contains(_searchQuery.toLowerCase()) ||
          tags.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _certificateBox.isOpen && _filteredCertificates.isEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Certificates')),
      body: Column(
        children: [
          // 🔍 Search Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📋 Certificate List or Empty State
          Expanded(
            child: !_certificateBox.isOpen
                ? const Center(child: CircularProgressIndicator())
                : isEmpty
                ? const EmptyStateView(
              title: 'No certificates found',
              subtitle: 'Add a certificate using the + button below',
            )
                : ListView.builder(
              itemCount: _filteredCertificates.length,
              itemBuilder: (context, index) {
                final entry = _filteredCertificates[index];
                return CertificateListItem(
                  certificate: entry.value,
                  certificateKey: entry.key,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CertificateDetailScreen(
                          certificate: entry.value,
                          certificateKey: entry.key,
                        ),
                      ),
                    ).then((_) => setState(() {})); // Refresh on return
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ➕ Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCertificateScreen()),
          );
          setState(() {}); // Refresh list after add
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
