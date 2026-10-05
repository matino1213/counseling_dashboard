/// رقم‌های فارسی برای نمایش تعداد و درصد.
const List<String> _faDigits = [
  '۰',
  '۱',
  '۲',
  '۳',
  '۴',
  '۵',
  '۶',
  '۷',
  '۸',
  '۹'
];

String faNumber(num value) {
  final text = value is int ? '$value' : value.toStringAsFixed(0);
  return text.split('').map((ch) {
    final digit = ch.codeUnitAt(0) - 48;
    return digit >= 0 && digit <= 9 ? _faDigits[digit] : ch;
  }).join();
}

/// «۴۵٪» برای درصدی بین ۰ تا ۱.
String faPercent(double fraction) => '${faNumber((fraction * 100).round())}٪';
