import 'dart:math';

import 'package:PiliPalaX/common/constants.dart';
import 'package:PiliPalaX/http/loading_state.dart';
import 'package:PiliPalaX/models/space/data.dart';
import 'package:PiliPalaX/pages/member/new/controller.dart';
import 'package:PiliPalaX/utils/grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberHome extends StatefulWidget {
  const MemberHome({super.key, this.heroTag});

  final String? heroTag;

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _ctr = Get.find<MemberControllerNew>(tag: widget.heroTag);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildBody(_ctr.loadingState.value);
  }

  Widget _buildBody(LoadingState loadingState) {
    return loadingState is Success && loadingState.response is Data
        ? CustomScrollView(
            slivers: [
              if (loadingState.response?.archive?.item?.isNotEmpty == true) ...[
                _videoHeader(
                  title: '视频',
                  param: 'contribute',
                  count: loadingState.response.archive.count,
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithExtentAndRatio(
                    mainAxisSpacing: StyleString.cardSpace,
                    crossAxisSpacing: StyleString.cardSpace,
                    maxCrossAxisExtent: Grid.maxRowWidth,
                    childAspectRatio: StyleString.aspectRatio,
                    mainAxisExtent: MediaQuery.textScalerOf(context).scale(90),
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        title: Text(
                            loadingState.response.archive.item[index].title),
                      );
                    },
                    childCount:
                        min(4, loadingState.response.archive.item.length),
                  ),
                ),
              ],
              if (loadingState.response?.season?.item?.isNotEmpty == true) ...[
                _videoHeader(
                  title: '追番',
                  param: 'bangumi',
                  count: loadingState.response.season.count,
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithExtentAndRatio(
                    mainAxisSpacing: StyleString.cardSpace - 2,
                    crossAxisSpacing: StyleString.cardSpace,
                    maxCrossAxisExtent: Grid.maxRowWidth / 3 * 2,
                    childAspectRatio: 0.65,
                    mainAxisExtent: MediaQuery.textScalerOf(context).scale(60),
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ListTile(
                        title: Text(
                            loadingState.response.season.item[index].title),
                      );
                    },
                    childCount:
                        min(3, loadingState.response.season.item.length),
                  ),
                ),
              ],
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _videoHeader({
    required String title,
    required String param,
    required int count,
  }) =>
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$title '),
                    TextSpan(
                      text: count.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  int index = _ctr.tab2!
                      .map((item) => item.param)
                      .toList()
                      .indexOf(param);
                  if (index != -1) {
                    _ctr.tabController.animateTo(index);
                  }
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '查看更多',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.top,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
