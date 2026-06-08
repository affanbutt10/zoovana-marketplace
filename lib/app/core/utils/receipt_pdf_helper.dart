import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Saves [pdfBytes] to a temp file and opens the system share sheet.
abstract final class ReceiptPdfHelper {
  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final dir = await getTemporaryDirectory();
    final safeName = fileName.replaceAll(RegExp(r'[^\w\-.]'), '_');
    final file = File('${dir.path}/$safeName.pdf');
    await file.writeAsBytes(pdfBytes, flush: true);
    await Share.shareXFiles([
      XFile(file.path, mimeType: 'application/pdf'),
    ], subject: safeName);
  }

  static Future<void> shareHtml({
    required String html,
    required String fileName,
  }) async {
    final dir = await getTemporaryDirectory();
    final safeName = fileName.replaceAll(RegExp(r'[^\w\-.]'), '_');
    final file = File('${dir.path}/$safeName.html');
    await file.writeAsString(html, flush: true);
    await Share.shareXFiles([
      XFile(file.path, mimeType: 'text/html'),
    ], subject: safeName);
  }
}
