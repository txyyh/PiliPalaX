import 'package:flutter/material.dart';

class MemberArchive extends StatefulWidget {
  const MemberArchive({super.key});

  @override
  State<MemberArchive> createState() => _MemberArchiveState();
}

class _MemberArchiveState extends State<MemberArchive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (_, index) => ListTile(
        title: Text(index.toString()),
      ),
    );
  }
}
