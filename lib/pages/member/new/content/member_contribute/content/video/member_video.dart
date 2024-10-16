import 'package:flutter/material.dart';

class MemberVideo extends StatefulWidget {
  const MemberVideo({
    super.key,
    required this.heroTag,
  });

  final String? heroTag;

  @override
  State<MemberVideo> createState() => _MemberVideoState();
}

class _MemberVideoState extends State<MemberVideo>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Text('Video'),
    );
  }
}
