import 'package:flutter/material.dart';

class MemberDynamic extends StatefulWidget {
  const MemberDynamic({super.key});

  @override
  State<MemberDynamic> createState() => _MemberDynamicState();
}

class _MemberDynamicState extends State<MemberDynamic>
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
