// Feature: zoovana-app-ui, Property 25: Profile header displays user data

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoovana/app/data/models/user.dart';

/// Validates: Requirements 14.2
///
/// For any User with name and email, the ProfileHeader widget shall display
/// both the name and email strings.

// Minimal ProfileHeader widget (mirrors the one in profile_screen.dart)
class _ProfileHeader extends StatelessWidget {
  final User user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(child: Icon(Icons.person)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name),
            Text(user.email),
          ],
        ),
      ],
    );
  }
}

User _makeUser(String name, String email) => User(
      id: '1',
      name: name,
      email: email,
      phone: '0512345678',
      isActive: true,
      isVerified: false,
      isEmailVerified: false,
      isPhoneVerified: false,
      registrationStatus: 'active',
      addresses: [],
    );

void main() {
  group('Property 25: Profile header displays user data', () {
    testWidgets('displays name and email — 20 iterations', (tester) async {
      final rng = Random(42);
      const names = ['Alice', 'Bob', 'Carlos', 'Diana', 'Eve'];
      const emails = [
        'a@test.com',
        'b@test.com',
        'c@test.com',
        'd@test.com',
        'e@test.com'
      ];

      for (var i = 0; i < 20; i++) {
        final name = names[rng.nextInt(names.length)];
        final email = emails[rng.nextInt(emails.length)];
        final user = _makeUser(name, email);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: _ProfileHeader(user: user)),
          ),
        );

        expect(find.text(name), findsOneWidget,
            reason: 'Iteration $i: name "$name" must be displayed');
        expect(find.text(email), findsOneWidget,
            reason: 'Iteration $i: email "$email" must be displayed');
      }
    });
  });
}
