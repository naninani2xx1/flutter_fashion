/// The `AppBarProductDetail` class is a stateless widget that displays the app bar for the product
/// detail screen, including icons for adding/removing the product from favorites and displaying the
/// number of items in the cart.
import 'package:flutter_fashion/app/blocs/cart/cart_cubit.dart';
import 'package:flutter_fashion/app/blocs/favorite/favorite_cubit.dart';
import 'package:flutter_fashion/app/models/product/product.dart';
import 'package:flutter_fashion/app/presentation/product_detail/inherited.dart';

import '../../../../export.dart';

class AppBarProductDetail extends StatelessWidget {
  const AppBarProductDetail({super.key});
  static GlobalKey cartKey = GlobalKey();

  static Offset getOffset() {
    final box = cartKey.currentContext!.findRenderObject() as RenderBox;

    Offset offset = box.localToGlobal(Offset.zero);
    offset = Offset(offset.dx - box.size.width * 3, 0);
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    final detailInherited = ProductDetailInherited.of(context);
    return SafeArea(
      child: LimitedBox(
        maxHeight: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: const Alignment(-1, -0.4),
                child: InkWell(
                  onTap: () => AppRoutes.router.pop(),
                  child: const Icon(Icons.arrow_back, size: 24),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: const Alignment(1, -0.4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: BlocSelector<FavoriteCubit, FavoriteState, bool>(
                        selector: (state) {
                          final product = detailInherited.productModel;

                          final favorites = state.listProduct;

                          if (favorites.isEmpty) {
                            return false;
                          }
                          return favorites.contains(product);
                        },
                        builder: (context, check) {
                          final product = detailInherited.productModel;
                          return _buildIconFavorite(context, product, check);
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () => AppRoutes.router.push(Routes.CART),
                      child: SizedBox(
                        key: cartKey,
                        width: 24.0,
                        height: 24.0,
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/cart.svg",
                            ),
                            Positioned(
                              right: -3,
                              top: -5,
                              child: DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: errorColor,
                                  shape: BoxShape.circle,
                                ),
                                child: SizedBox(
                                  width: 15.0,
                                  height: 15.0,
                                  child: Center(
                                    child: BlocBuilder<CartCubit, CartState>(
                                      builder: (context, state) {
                                        return Text(
                                          state.items.length.toString(),
                                          style: PrimaryFont.instance.copyWith(
                                            fontSize: 9.0,
                                            color: lightColor,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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

  _buildIconFavorite(
      BuildContext context, ProductModel product, bool isFavorite) {
    return InkWell(
      onTap: () {
        if (isFavorite) {
          context.read<FavoriteCubit>().removeFavorite(product);
        } else {
          context.read<FavoriteCubit>().addFavorite(product);
        }
      },
      child: SvgPicture.asset(
        "assets/icons/favorite.svg",
        color: isFavorite ? null : disableDarkColor.withOpacity(0.2),
      ),
    );
  }
}
