extension StringExt on String {
  String toTitleCase() {
    final String titleCaseVar = split(' ').map((String word) => word[0].toUpperCase() + word.substring(1)).join(' ');

    return titleCaseVar;
  }

  String removeZeroLeft() {
    if (startsWith('0')) {
      return substring(1);
    }
    return this;
  }

  String removeZeroLeftDecimal() {
    if (startsWith('0.')) {
      return substring(2);
    }
    return this;
  }

// remove 0. from the string and add % percentage symbol
  String removeZeroLeftDecimalPercentage() {
    if (toString() == '0') {
      return '0';
    } else if (startsWith('0.')) {
      final double value = double.parse(this);
      return (value * 100).toStringAsFixed(0);
    } else if (length == 1) {
      return '${toString()}00';
    }
    return this;
  }

  // convert 0.9 to 90% and 0.09 to 9% and .95 to 95%
  String convertToPercentage() {
    if (toString() == '0') {
      return '0%';
    } else if (startsWith('0.')) {
      final double value = double.parse(this);
      return '${(value * 100).toStringAsFixed(0)}%';
    } else if (length == 1) {
      return '${toString()}00%';
    }
    return this;
  }
}
