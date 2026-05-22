import 'package:flutter/material.dart';
import 'package:trainner_app/app_shared.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Members')),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Text('DK')),
            title: Text(SeedData.memberName),
            subtitle: const Text('Active member'),
          ),
        ],
      ),
    );
  }
}
