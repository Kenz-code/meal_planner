import 'package:flutter/material.dart';

final Color neutral100 = HexColor.fromHex("F0F2F0");
final Color neutral200 = HexColor.fromHex("D1D8D1");
final Color neutral300 = HexColor.fromHex("B3BEB3");
final Color neutral600 = HexColor.fromHex("5C6B5C");
final Color neutral700 = HexColor.fromHex("414C41");
final Color neutral800 = HexColor.fromHex("272E27");
final Color neutral900 = HexColor.fromHex("0D0F0D");
final Color primary600 = HexColor.fromHex("27B115");
final Color primary300 = HexColor.fromHex("8DF080");
final Color primary200 = HexColor.fromHex("BBF6B3");
final Color error600 = HexColor.fromHex("B11515");
final Color primary700 = HexColor.fromHex("1C7F0F");
final Color second600 = HexColor.fromHex("9F15B1");
final Color primary400 = HexColor.fromHex("60EA4E");
final Color error300 = HexColor.fromHex("F08080");


extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}