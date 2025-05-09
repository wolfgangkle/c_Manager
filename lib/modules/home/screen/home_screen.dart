import 'package:flutter/material.dart';
import 'package:c_manager/modules/certificate_list/widgets/certificate_list_item.dart';
import 'package:c_manager/modules/certificate_list/widgets/empty_state_view.dart';
import 'package:c_manager/modules/certificate_list/screen/add_certificate_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _editMode = false;

  final List<Map<String, dynamic>> _allCertificates = [];

  List<Map<String, dynamic>> get _filteredCertificates {
    if (_searchQuery.isEmpty) return _allCertificates;
    return _allCertificates.where((cert) {
      final title = (cert['title'] as String).toLowerCase();
      final tags = (cert['tags'] as List<String>).join(' ').toLowerCase();
      return title.contains(_searchQuery.toLowerCase()) ||
          tags.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  int _calculateRemainingDays(String isoDate) {
    final expiryDate = DateTime.parse(isoDate);
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final hasCertificates = _filteredCertificates.isNotEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            titleSpacing: 0,
            leadingWidth: 80,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 60,
                child: TextButton(
                  onPressed: () => setState(() => _editMode = !_editMode),
                  child: Text(
                    _editMode ? 'Done' : 'Edit',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              const SizedBox(width: 4),
              _buildTinyIcon(Icons.add, 'Add', () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddCertificateScreen()),
                );

                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _allCertificates.add({
                      'title': result['name'],
                      'tags': ['General'], // Temporary default tags
                      'days': _calculateRemainingDays(result['expiry']),
                    });
                  });
                }
              }),
              _buildTinyIcon(Icons.label, 'Tags', () {
                // TODO: Tags
              }),
              _buildTinyIcon(Icons.settings, 'Settings', () {
                // TODO: Settings
              }),
              _buildTinyIcon(Icons.filter_list, 'Filters', () {
                // TODO: Filters
              }),
              const SizedBox(width: 8),
            ].reversed.toList(),
          ),

          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _SearchBarDelegate(
              searchController: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          hasCertificates
              ? SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final cert = _filteredCertificates[index];
                return CertificateListItem(
                  title: cert['title'] as String,
                  tags: List<String>.from(cert['tags']),
                  daysRemaining: cert['days'] as int,
                );
              },
              childCount: _filteredCertificates.length,
            ),
          )
              : SliverFillRemaining(
            hasScrollBody: false,
            child: const EmptyStateView(
              title: 'No certificates yet',
              subtitle: 'Tap + to add your first certificate.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTinyIcon(IconData icon, String tooltip, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, size: 20, color: Colors.blue),
      tooltip: tooltip,
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final ValueChanged<String> onChanged;

  _SearchBarDelegate({
    required this.searchController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search certificates...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
