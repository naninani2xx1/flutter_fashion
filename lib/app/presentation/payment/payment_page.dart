import 'package:flutter_fashion/app/blocs/cart/cart_cubit.dart';
import 'package:flutter_fashion/app/blocs/payment/payment.dart';
import 'package:flutter_fashion/app/blocs/payment/payment_state.dart';
import 'package:flutter_fashion/app/presentation/payment/components/address_view.dart';
import 'package:flutter_fashion/app/presentation/payment/components/detail_order_view.dart';
import 'package:flutter_fashion/app/presentation/payment/components/infor_user_order_view.dart';
import 'package:flutter_fashion/app/presentation/payment/components/list_order_view.dart';
import 'package:flutter_fashion/app/presentation/payment/components/list_voucher_view.dart';
import 'package:flutter_fashion/app/presentation/payment/components/method_payment_view.dart';
import 'package:flutter_fashion/app/presentation/payment/components/rules_app_view.dart';
import 'package:flutter_fashion/app/presentation/personal_information/export.dart';
import 'package:flutter_fashion/core/status_cubit/status_cubit.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackgroundBlur.scroll(
      isHasBackground: false,
      centerTitle: false,
      title: "Đơn hàng",
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state.status == AppStatus.success) {
            context.read<CartCubit>().removeAll();
            context.read<PaymentCubit>().removeAll();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            AddressPaymentView(),
            ListOrderView(),
            InfoUserOrderView(),
            MethodPaymentView(),
            ListVoucherView(),
            DetailOrderView(),
            RulesAppView(),
          ],
        ),
      ),
    );
  }
}
