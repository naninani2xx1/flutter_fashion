// ignore_for_file: deprecated_member_use
import 'package:flutter_fashion/app/presentation/create_address/blocs/address_management.dart';
import 'package:flutter_fashion/app/presentation/create_address/components/commune_list.dart';
import 'package:flutter_fashion/app/presentation/create_address/components/desc_address.dart';
import 'package:flutter_fashion/app/presentation/create_address/components/district_list.dart';
import 'package:flutter_fashion/app/presentation/create_address/components/province_list.dart';
import 'package:flutter_fashion/app/presentation/create_address/components/view_seleted_address.dart';
import 'package:flutter_fashion/common/components/app/background_app.dart';
import '../../../config/svg_files.dart';
import '../../../export.dart';

class CreateAddressPage extends StatelessWidget {
  const CreateAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<AddressManagementBloc>();
    return AppBackgroundBlur.normal(
      leading: InkWell(
        onTap: () {
          AppRoutes.router.pop();
          bloc.reset();
        },
        child: const Icon(
          Icons.arrow_back,
          size: 20,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Builder(
          builder: (context) {
            return StreamBuilder<ListBuilding>(
              stream: bloc.buildingStream.stream,
              builder: (context, snapshot) {
                if (snapshot.data == ListBuilding.desc) {
                  return ButtonWidget(
                    height: 45.0,
                    onPressed: () => getIt<AddressManagementBloc>()
                        .submitCreateAddress(context),
                    child: Text(
                      AppLocalizations.of(context)!.create,
                      style: PrimaryFont.instance.copyWith(
                        fontSize: 14.0,
                        color: lightColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            );
          },
        ),
      ),
      title: AppLocalizations.of(context)!.create_new_address,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding - 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<List<String>>(
              stream: bloc.seletedListStream.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return ButtonWidget(
                    height: 45.0,
                    onPressed: () => getIt<AddressManagementBloc>()
                        .getCurrentLocation(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Assets.locationSVG,
                          color: lightColor,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          AppLocalizations.of(context)!.get_current_location,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 14.0,
                                    color: lightColor,
                                  ),
                        ),
                      ],
                    ),
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.seleted_address,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                    ),
                    InkWell(
                      onTap: () => bloc.reset(),
                      child: SvgPicture.asset(
                        Assets.trashSVG,
                        fit: BoxFit.contain,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          textDisable,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8.0),
            const ViewSelectedAddress(),
            const SizedBox(height: 15.0),
            Expanded(
              child: StreamBuilder<ListBuilding>(
                stream: bloc.buildingStream.stream,
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.waiting)) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('ERROR'));
                  }

                  if (snapshot.data! == ListBuilding.province) {
                    return const ProvinceList();
                  }

                  if (snapshot.data! == ListBuilding.district) {
                    return const DistrictList();
                  }

                  if (snapshot.data! == ListBuilding.commnue) {
                    return const CommuneList();
                  }
                  if (snapshot.data! == ListBuilding.desc) {
                    return const DescAddress();
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
