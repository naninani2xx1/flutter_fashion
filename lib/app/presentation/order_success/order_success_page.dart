import 'package:flutter_fashion/app/presentation/personal_information/export.dart';
import 'package:lottie/lottie.dart';

import '../../../config/svg_files.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBackgroundBlur.withAppBar(
      autoLeading: false,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Lottie.asset(
                "assets/json/order-success.json",
                repeat: false,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.order_successfully,
              style: theme.textTheme.bodyLarge,
            ),
            IconButton(
              onPressed: () => AppRoutes.router.go(Routes.HOME),
              icon: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.homeSVG,
                      colorFilter: const ColorFilter.mode(
                          secondaryColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      AppLocalizations.of(context)!.homePage,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: darkColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
