import 'package:flutter_fashion/app/models/address/address.dart';
import 'package:flutter_fashion/app/presentation/create_address/blocs/address_management.dart';
import 'package:flutter_fashion/export.dart';

class ProvinceList extends StatelessWidget {
  const ProvinceList({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<AddressManagementBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.province_city,
          style: PrimaryFont.instance.small(),
        ),
        Expanded(
          child: StreamBuilder<List<ItemProvinceModel>>(
            stream: bloc.provinceStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data!.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              final data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () => bloc.selectProvince(item),
                        horizontalTitleGap: 0.0,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        leading: Text(
                          item.name,
                          style: PrimaryFont.instance.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Divider(color: disableDarkColor.withOpacity(0.1)),
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
