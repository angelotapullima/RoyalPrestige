import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/bloc/provider_bloc.dart';
import 'package:royal_prestige/src/model/percent_calculate_model.dart';

class PercentWidget extends StatelessWidget {
  const PercentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentBloc = ProviderBloc.pencert(context);
    return StreamBuilder<List<PercentCaculateModel>>(
      stream: percentBloc.percentsStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Column(
            children: snapshot.data!.map((d) => item(d)).toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget item(PercentCaculateModel item) {
    double porcentaje = double.parse(item.value.toString()) * 100;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${porcentaje.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'S/. ${item.monto ?? "0.00"}',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
