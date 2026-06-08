import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

/// Floating action button that opens WhatsApp chat via `https://wa.me/966XXXXXXXXX`.
///
/// Uses `whatsapp.svg` as the icon (rendered via [Image.asset]).
/// Background color is WhatsApp green.
class WhatsAppFab extends StatelessWidget {
  static const _whatsappUrl = 'https://wa.me/966XXXXXXXXX';
  static const _whatsappGreen = Color(0xFF25D366);

  const WhatsAppFab({super.key});

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse(_whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _openWhatsApp,
      backgroundColor: _whatsappGreen,
      tooltip: 'Chat on WhatsApp',
      child: SvgPicture.asset(
        'assests/whatsapp.svg',
        width: 28,
        height: 28,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
        placeholderBuilder: (context) => const Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }
}
