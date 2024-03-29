import 'package:flutter_fashion/app/blocs/auth/auth_cubit.dart';
import 'package:flutter_fashion/app/blocs/auth_phone/auth_phone_cubit.dart';
import 'package:flutter_fashion/app/presentation/sign_up/components/filling_out_information_personal.dart';
import 'package:flutter_fashion/app/presentation/sign_up/cubit/sign_up_cubit.dart';
import 'package:flutter_fashion/app/presentation/sign_up/sign_up_page.dart';
import 'package:flutter_fashion/export.dart';

class SubmitSignUp extends StatelessWidget {
  const SubmitSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final applocalization = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    final bloc = context.read<AuthPhoneCubit>();

    final authBloc = context.read<AuthCubit>();

    final blocUI = context.read<SignUpUICubit>();

    final blocListen = context.watch<SignUpUICubit>();
    return ButtonWidget(
      onPressed: () {
        if (blocListen.state == 0) {
          bloc.phoneAuth(SignUpPage.phoneNumber, context, Names.REGISTER);
        }
        if (blocListen.state == 1) {
          bloc.verifyOtp(SignUpPage.phoneNumber, SignUpPage.codeOTP, context,
              SignUpPage.verificationId);
        }
        if (blocListen.state == 2) {
          blocUI.nextStep(SignUpUIState.enterPassword);
        }
        if (blocListen.state == 3) {
          if (!FillingOutInformationPersonalCpn.password.isValidPassword ||
              !FillingOutInformationPersonalCpn.confirm.isValidPassword) {
            showErrorToast(applocalization.text_validate_valid_pass);

            return;
          }
          if (!FillingOutInformationPersonalCpn.checkMatchPassword) {
            showErrorToast(applocalization.password_not_match);

            return;
          }
          if (FillingOutInformationPersonalCpn.image == null) {
            showErrorToast(applocalization.please_choose_avatar);

            return;
          }
          authBloc.accountRegister(
              FillingOutInformationPersonalCpn.params, context);
        }
      },
      child: Text(
        (blocListen.state == 3)
            ? applocalization.completed
            : applocalization.continue_r,
        style: textTheme.bodyMedium!.copyWith(
          fontSize: 14.0,
          color: lightColor,
        ),
      ),
    );
  }
}
