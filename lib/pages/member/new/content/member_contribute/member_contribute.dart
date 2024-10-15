import 'package:flutter/material.dart';

class MemberContribute extends StatefulWidget {
  const MemberContribute({super.key});

  @override
  State<MemberContribute> createState() => _MemberContributeState();
}

class _MemberContributeState extends State<MemberContribute>
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
