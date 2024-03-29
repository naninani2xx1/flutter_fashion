import 'package:equatable/equatable.dart';

import '../../../config/svg_files.dart';
import '../../../export.dart';

enum OrderStatus {
  toPay,
  toShip,
  toReceive,
  completed,
  canceled,
}

const String toPay = "ToPay";
const String toShip = "ToShip";
const String toReceive = "ToReceive";
const String completed = "completed";
const String canceled = "canceled";

class ChoiceChipCustom extends Equatable {
  final int id;
  final String label;
  final Widget prefixIcon;
  const ChoiceChipCustom({
    required this.id,
    required this.label,
    required this.prefixIcon,
  });

  @override
  List<Object?> get props => [id, label, prefixIcon];

  static List<ChoiceChipCustom> get listData => [
        ChoiceChipCustom(
          id: 1,
          label: toPay,
          prefixIcon: SvgPicture.asset(
            Assets.walletSVG,
          ),
        ),
        ChoiceChipCustom(
          id: 2,
          label: toShip,
          prefixIcon: SvgPicture.asset(
            Assets.orderBoxSVG,
          ),
        ),
        const ChoiceChipCustom(
          id: 3,
          label: toReceive,
          prefixIcon: Icon(
            Icons.local_shipping,
            size: 22.0,
            color: secondaryColor,
          ),
        ),
        const ChoiceChipCustom(
          id: 4,
          label: completed,
          prefixIcon: Icon(
            Icons.check_circle,
            color: secondaryColor,
          ),
        ),
        const ChoiceChipCustom(
          id: 5,
          label: canceled,
          prefixIcon: Icon(
            Icons.cancel,
            size: 22.0,
            color: secondaryColor ,
          ),
        ),
      ];
}
