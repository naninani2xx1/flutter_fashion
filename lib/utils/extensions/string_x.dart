import 'package:flutter/material.dart';
import 'package:flutter_fashion/app/presentation/order/constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../routes/app_routes.dart';

extension StringX on String {
  // ///Accepts encrypted data and decrypt it. Returns plain text
  // String decryptWithAES(String key, ecp.Encrypted encryptedData) {
  //   final cipherKey = ecp.Key.fromUtf8(key);
  //   final encryptService = ecp.Encrypter(
  //       ecp.AES(cipherKey, mode: ecp.AESMode.cbc)); //Using AES CBC encryption
  //   final initVector = ecp.IV.fromUtf8(key.substring(0,
  //       16)); //Here the IV is generated from key. This is for example only. Use some other text or random data as IV for better security.

  //   return encryptService.decrypt(encryptedData, iv: initVector);
  // }

  String translateTabOrder(BuildContext context) {
    switch (this) {
      case toPay:
        return AppLocalizations.of(context)!.to_pay;
      case toShip:
        return AppLocalizations.of(context)!.to_ship;
      case toReceive:
        return AppLocalizations.of(context)!.to_receive;
      case completed:
        return AppLocalizations.of(context)!.completed;
      case canceled:
        return AppLocalizations.of(context)!.canceled;
      default:
    }
    return "";
  }

  String translateLabelBottomNavigationBar(BuildContext context) {
    switch (this) {
      case Routes.HOME:
        return AppLocalizations.of(context)!.homePage;
      case Routes.NOTIFICATION:
        return AppLocalizations.of(context)!.notificationPage;
      case Routes.PROFILE:
        return AppLocalizations.of(context)!.mePage;
      default:
    }
    return "";
  }

  String translateLabelFeatureProfile(BuildContext context) {
    switch (this) {
      case Names.PERSONAL:
        return AppLocalizations.of(context)!.personal;
      case Names.ORDER:
        return AppLocalizations.of(context)!.order;
      case Names.MESSENGER:
        return AppLocalizations.of(context)!.messenger;
      case Names.ADDRESS_MANAGEMENT:
        return AppLocalizations.of(context)!.address;
      case Names.FAVORITE:
        return AppLocalizations.of(context)!.favorite;
      case Names.SETTING:
        return AppLocalizations.of(context)!.setting;
      default:
    }
    return "";
  }

  String toBeginningOfSentenceCase() =>
      this[0].toUpperCase() + substring(1).toLowerCase();

  String toFormattedPhoneNumberVN() {
    if (length != 10) {
      return this;
    }
    const prefix = '+84';
    final thirdPart = substring(7, 10);
    return '($prefix) *** *** $thirdPart';
  }

  bool isValidEmail() {
    // Kiểm tra xem chuỗi có rỗng hay không
    if (isEmpty) return false;

    // Kiểm tra xem chuỗi có phù hợp với yêu cầu đặc biệt không
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final String emailDomain = split('@').last;
    return emailRegex.hasMatch(this) &&
        emailDomain.contains('gmail') &&
        endsWith('.com');
  }

  bool get isValidPassword {
    final RegExp passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?\d)(?=.*?[!@#\$&*~])[A-Za-z\d!@#\$&*~]{7,}$');
    return passwordRegex.hasMatch(this);
  }
}
