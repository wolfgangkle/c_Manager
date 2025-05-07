import 'package:flutter/material.dart';
import 'package:c_manager/modules/certificate_list/widgets/certificate_list_item.dart';
import 'package:c_manager/modules/certificate_list/widgets/empty_state_view.dart';


class CertificateListScreen extends StatefulWidget {
  const CertificateListScreen({super.key});

  @override
  State<CertificateListScreen> createState() => _CertificateListScreenState();
}

class _CertificateListScreenState extends State<CertificateListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // This list can be empty to test the empty state
  final List<Map<String, dynamic>> _allCertificates = [
    // Example data here (or leave it empty to test)
  ];

  List<Map<String, dynamic>> get _filteredCertificates {
    if (_searchQuery.isEmpty) return _allCertificates;
    return _allCertificates.where((cert) {
      final title = (cert['title'] as String).toLowerCase();
      final tags = (cert['tags'] as List<String>).join(' ').toLowerCase();
      return title.contains(_searchQuery.toLowerCase()) ||
          tags.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _filteredCertificates.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Certificates'),
      ),
      body: Column(
        children: [
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
          Expanded(
            child: isEmpty
                ? const EmptyStateView(
              title: 'No certificates found',
              subtitle: 'Add a certificate using the + button below',
            )

                : ListView.builder(
              itemCount: _filteredCertificates.length,
              itemBuilder: (context, index) {
                final cert = _filteredCertificates[index];
                return CertificateListItem(
                  title: cert['title'] as String,
                  tags: List<String>.from(cert['tags']),
                  daysRemaining: cert['days'] as int,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Certificate',
        onPressed: () {
          // TODO: Navigate to AddCertificate screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
