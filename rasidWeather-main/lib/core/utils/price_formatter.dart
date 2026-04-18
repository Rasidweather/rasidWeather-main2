class PriceFormatter {
  /// Formats a price value to a shortened format (e.g., 1.5K, 1.2M) with tooltip support
  /// 
  /// Example:
  /// ```dart
  /// final formattedPrice = PriceFormatter.formatPrice(1500); // Returns "1.5K"
  /// final formattedPrice = PriceFormatter.formatPrice(1200000); // Returns "1.2M"
  /// ```
  static String formatPrice(dynamic price) {
    if (price == null) return '0';
    
    // Convert price to double
    double numericPrice = 0.0;
    if (price is String) {
      numericPrice = double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
    } else if (price is num) {
      numericPrice = price.toDouble();
    }

    String formatWithSuffix(double value, String suffix) {
      final double divided = value / (suffix == 'B' ? 1000000000 : suffix == 'M' ? 1000000 : 1000);
      String formatted = divided.toStringAsFixed(1);
      // Remove .0 if present
      if (formatted.endsWith('.0')) {
        formatted = formatted.substring(0, formatted.length - 2);
      }
      return '$formatted$suffix';
    }

    if (numericPrice >= 1000000000) {
      return formatWithSuffix(numericPrice, 'B');
    } else if (numericPrice >= 1000000) {
      return formatWithSuffix(numericPrice, 'M');
    } else if (numericPrice >= 1000) {
      return formatWithSuffix(numericPrice, 'K');
    }
    
    final String formatted = numericPrice.toStringAsFixed(2);
    // Remove .00 if there are no decimal places
    if (formatted.endsWith('.00')) {
      return formatted.substring(0, formatted.length - 3);
    }
    return formatted;
  }

  /// Formats a price value to its full format with commas
  /// 
  /// Example:
  /// ```dart
  /// final fullPrice = PriceFormatter.formatFullPrice(1500); // Returns "1,500.00"
  /// ```
  static String formatFullPrice(dynamic price) {
    if (price == null) return '0.00';
    
    // Convert price to double
    double numericPrice = 0.0;
    if (price is String) {
      numericPrice = double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
    } else if (price is num) {
      numericPrice = price.toDouble();
    }

    // Format with thousand separators
    final List<String> parts = numericPrice.toStringAsFixed(2).split('.');
    final String wholePart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},'
    );
    
    // Remove .00 if there are no decimal places
    if (parts[1] == '00') {
      return wholePart;
    }
    return '$wholePart.${parts[1]}';
  }
}
