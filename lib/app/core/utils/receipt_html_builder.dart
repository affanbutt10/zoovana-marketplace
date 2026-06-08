import 'dart:convert';

import '../../data/models/receipt.dart';

abstract final class ReceiptHtmlBuilder {
  static String build(Receipt receipt) {
    final rows = receipt.items
        .map(
          (item) =>
              '''
          <tr>
            <td>${_e(item.productName.isNotEmpty ? item.productName : item.sku ?? 'Product')}</td>
            <td>${item.quantity}</td>
            <td>${item.unitPrice.toStringAsFixed(2)} ${_e(item.currency)}</td>
            <td>${item.totalPrice.toStringAsFixed(2)} ${_e(item.currency)}</td>
          </tr>
        ''',
        )
        .join();

    final sellerSections = receipt.businessGroups
        .map(
          (group) =>
              '''
          <div class="seller-section">
            <div class="seller-header">${_e(group.businessName)}</div>
            ${group.branchPhone == null ? '' : '<div><strong>Phone:</strong> ${_e(group.branchPhone!)}</div>'}
            <div>Items: ${group.itemCount} | Subtotal: ${group.subtotal.toStringAsFixed(2)} ${_e(receipt.currency)}</div>
          </div>
        ''',
        )
        .join();

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Receipt ${_e(receipt.number)}</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 0; padding: 8px; background: #fff; color: #1f2937; }
    .invoice-container { max-width: 760px; margin: 0 auto; border: 1px solid #111827; padding: 12px; background: white; }
    .header { text-align: center; margin-bottom: 12px; color: #003366; }
    .company-info, .customer, .seller-section { background: #f5f7fa; border: 1px solid #e5e7eb; border-radius: 6px; padding: 10px; margin-bottom: 14px; }
    .company-logo { font-size: 22px; font-weight: 800; color: #003366; text-align: center; margin-bottom: 8px; }
    .divider { border-top: 2px solid #003366; margin: 14px 0; }
    .detail-row { display: grid; grid-template-columns: 140px 1fr; gap: 8px; margin-bottom: 8px; }
    .detail-label { font-weight: 700; }
    .status-badge { display: inline-block; padding: 4px 8px; border-radius: 4px; background: #d4edda; color: #155724; font-size: 11px; font-weight: 800; text-transform: uppercase; }
    .seller-header { font-weight: 800; color: #003366; margin-bottom: 6px; }
    table { width: 100%; border-collapse: collapse; margin: 16px 0; }
    th { background: #003366; color: white; padding: 8px; font-size: 12px; }
    td { padding: 8px; border: 1px solid #e5e7eb; text-align: center; font-size: 12px; }
    td:first-child { text-align: left; }
    .totals td { border: none; border-bottom: 1px solid #e5e7eb; }
    .total { font-weight: 800; background: #f0f4f8; border-top: 2px solid #003366 !important; }
    .footer-note { text-align: center; font-size: 11px; color: #6b7280; border-top: 1px solid #e5e7eb; padding-top: 12px; margin-top: 16px; }
  </style>
</head>
<body>
  <div class="invoice-container">
    <div class="header">
      <h1>Zoovana Marketplace - Receipt</h1>
    </div>
    <div class="company-info">
      <div class="company-logo">Zoovana Marketplace</div>
      <div><strong>Your Marketplace Partner</strong></div>
      <div><strong>VAT Registration Number:</strong> 300000000000003</div>
    </div>
    <div class="divider"></div>
    <div class="detail-row"><div class="detail-label">Receipt Number:</div><div>${_e(receipt.number)}</div></div>
    <div class="detail-row"><div class="detail-label">Issue Date:</div><div>${_e(receipt.date.toLocal().toString().split('.').first)}</div></div>
    <div class="detail-row"><div class="detail-label">Status:</div><div><span class="status-badge">${_e(receipt.status)}</span></div></div>
    <div class="customer">
      <h4>Customer Information</h4>
      <div><strong>Name:</strong> ${_e(receipt.clientName ?? '')}</div>
      <div><strong>Email:</strong> ${_e(receipt.clientEmail ?? '')}</div>
      <div><strong>Phone:</strong> ${_e(receipt.clientPhone ?? '')}</div>
    </div>
    ${sellerSections.isEmpty ? '' : '<h4>Order Summary by Seller</h4>$sellerSections'}
    <table>
      <thead>
        <tr><th>Product Name</th><th>Quantity</th><th>Unit Price</th><th>Total</th></tr>
      </thead>
      <tbody>${rows.isEmpty ? '<tr><td colspan="4">No line items available</td></tr>' : rows}</tbody>
    </table>
    <table class="totals">
      <tr><td>Subtotal</td><td style="text-align:right">${receipt.subtotal.toStringAsFixed(2)} ${_e(receipt.currency)}</td></tr>
      <tr><td>Discount</td><td style="text-align:right">${receipt.discountAmount.toStringAsFixed(2)} ${_e(receipt.currency)}</td></tr>
      <tr><td>VAT</td><td style="text-align:right">${receipt.taxAmount.toStringAsFixed(2)} ${_e(receipt.currency)}</td></tr>
      <tr><td>Shipping</td><td style="text-align:right">${receipt.shippingTotal.toStringAsFixed(2)} ${_e(receipt.currency)}</td></tr>
      <tr><td class="total">Total Amount</td><td class="total" style="text-align:right">${receipt.total.toStringAsFixed(2)} ${_e(receipt.currency)}</td></tr>
    </table>
    <div class="footer-note">Thank you for your business. This is a computer-generated document.</div>
  </div>
</body>
</html>
''';
  }

  static String _e(String value) => const HtmlEscape().convert(value);
}
