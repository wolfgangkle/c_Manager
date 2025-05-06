import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {  const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'cManager+',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
    ),
    home: const CertificateListScreen(),
  );
}
}

class CertificateListScreen extends StatelessWidget {
  const CertificateListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Certificates'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.assignment_turned_in),
            title: Text('Sea Survival'),
            subtitle: Text('Expires in 45 days'),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(Icons.assignment_turned_in),
            title: Text('Working at Heights'),
            subtitle: Text('Expired 3 days ago'),
            trailing: Icon(Icons.warning, color: Colors.red),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Later: Open add certificate screen
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Certificate',
      ),
    );
  }
}
