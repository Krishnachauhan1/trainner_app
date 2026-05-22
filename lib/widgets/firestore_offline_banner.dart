import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Orange strip when Firestore cannot reach Google servers.
class FirestoreOfflineBanner extends StatefulWidget {
  const FirestoreOfflineBanner({super.key});

  @override
  State<FirestoreOfflineBanner> createState() => _FirestoreOfflineBannerState();
}

class _FirestoreOfflineBannerState extends State<FirestoreOfflineBanner> {
  bool? _online;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final ok = await _isServerReachable();
    if (mounted) setState(() => _online = ok);
  }

  static Future<bool> _isServerReachable() async {
    try {
      await FirebaseFirestore.instance
          .collection('_ping')
          .doc('probe')
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 8));
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_online != false) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Colors.orange.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: const Text(
        'Firestore offline — add debug SHA-1 in Firebase (gymapp-d73bc) or check emulator internet. Chat uses local cache only.',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
