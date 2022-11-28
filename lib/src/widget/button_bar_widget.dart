import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:royal_prestige/src/pages/tabs/tab_model.dart';
import 'package:royal_prestige/src/utils/responsive.dart';

class ButtonBarWidget extends StatelessWidget {
  const ButtonBarWidget({
    super.key,
    required this.onTap,
    required this.responsive,
    required this.color,
    required this.data,
  });
  final VoidCallback onTap;
  final Responsive responsive;
  final Color color;
  final TabModel data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: responsive.hp(1)),
          Icon(
            data.icon,
            size: responsive.ip(3),
            color: color,
          ),
          Text(
            data.title,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(12),
              color: color,
            ),
          )
        ],
      ),
    );
  }
}
