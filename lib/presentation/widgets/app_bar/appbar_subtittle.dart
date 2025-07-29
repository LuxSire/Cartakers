import 'package:flutter/material.dart';

class AppbarSubtitle extends StatelessWidget {
  const AppbarSubtitle({
    super.key,
    required this.text,
    this.onTap,
    this.margin,
  });

  final String text;
  final Function? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: SizedBox(
          //  width: MediaQuery.of(context).size.width * 0.4, //
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ),
    );
  }
}
