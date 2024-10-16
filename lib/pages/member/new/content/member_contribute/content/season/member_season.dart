import 'package:flutter/material.dart';

class MemberSeason extends StatefulWidget {
  const MemberSeason({
    super.key,
    required this.seasonId,
    required this.heroTag,
  });

  final int seasonId;
  final String? heroTag;

  @override
  State<MemberSeason> createState() => _MemberSeasonState();
}

class _MemberSeasonState extends State<MemberSeason>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text(widget.seasonId.toString()),
    );
  }
}
