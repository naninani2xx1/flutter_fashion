import 'package:flutter_fashion/app/presentation/filter/components/title_frame.dart';
import 'package:flutter_fashion/app/presentation/filter/cubit/filter_cubit.dart';
import 'package:flutter_fashion/common/widgets/flash_sale_widget.dart';
import 'package:flutter_fashion/common/widgets/popular.dart';
import '../../../../export.dart';

class ServiceFrame extends StatelessWidget {
  const ServiceFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final filterCubit = context.read<FilterCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleFilterFrame(title: AppLocalizations.of(context)!.product_type),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: BlocBuilder<FilterCubit, FilterState>(
            buildWhen: (previous, current) =>
                previous.isSale != current.isSale ||
                previous.isPopular != current.isPopular,
            builder: (context, state) {
              final bool isPopular = state.isPopular;
              final bool isSale = state.isSale;
              return Row(
                children: [
                  _buildItem(
                    context,
                    tag: const PopularWidget(),
                    isSelected: isPopular,
                    onTap: () => filterCubit.selectPopular(!isPopular),
                  ),
                  _buildItem(
                    context,
                    tag: const FlashSaleWidget(),
                    isSelected: isSale,
                    onTap: () => filterCubit.selectSale(!isSale),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  InkWell _buildItem(context,
      {Widget? tag, bool isSelected = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: darkColor),
              ),
              child: AnimatedCrossFade(
                duration: const Duration(milliseconds: 450),
                secondChild: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 15,
                    height: 15,
                  ),
                ),
                firstChild: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkColor,
                    ),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
                firstCurve: Curves.easeIn,
                secondCurve: Curves.easeIn,
                crossFadeState: isSelected
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
            const SizedBox(width: 8.0),
            tag!,
          ],
        ),
      ),
    );
  }
}
