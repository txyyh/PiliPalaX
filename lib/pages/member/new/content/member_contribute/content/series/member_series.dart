import 'package:flutter/material.dart';

class MemberSeries extends StatefulWidget {
  const MemberSeries({
    super.key,
    required this.seriesId,
    required this.heroTag,
  });

  final int seriesId;
  final String? heroTag;

  @override
  State<MemberSeries> createState() => _MemberSeriesState();
}

class _MemberSeriesState extends State<MemberSeries>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text(widget.seriesId.toString()),
    );
  }
}
