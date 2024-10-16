import 'package:PiliPalaX/pages/member/new/content/member_contribute/content/article/member_article.dart';
import 'package:PiliPalaX/pages/member/new/content/member_contribute/content/audio/member_audio.dart';
import 'package:PiliPalaX/pages/member/new/content/member_contribute/content/season/member_season.dart';
import 'package:PiliPalaX/pages/member/new/content/member_contribute/content/series/member_series.dart';
import 'package:PiliPalaX/pages/member/new/content/member_contribute/content/video/member_video.dart';
import 'package:PiliPalaX/pages/member/new/content/member_contribute/member_contribute_ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberContribute extends StatefulWidget {
  const MemberContribute({
    super.key,
    this.heroTag,
    this.initialIndex,
  });

  final String? heroTag;
  final int? initialIndex;

  @override
  State<MemberContribute> createState() => _MemberContributeState();
}

class _MemberContributeState extends State<MemberContribute>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _controller = Get.put(
    MemberContributeCtr(
      heroTag: widget.heroTag,
      initialIndex: widget.initialIndex,
    ),
    tag: widget.heroTag,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _controller.tabs != null
        ? Column(
            children: [
              ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: TabBar(
                    isScrollable: true,
                    tabs: _controller.tabs!,
                    controller: _controller.tabController,
                    dividerHeight: 0,
                    indicatorWeight: 0,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: const TextStyle(fontSize: 14),
                    labelColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    unselectedLabelColor: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller.tabController,
                  children: _controller.items!
                      .map(
                        (item) => switch (item.param) {
                          'video' => MemberVideo(heroTag: widget.heroTag),
                          'article' => MemberArticle(heroTag: widget.heroTag),
                          'audio' => MemberAudio(heroTag: widget.heroTag),
                          'season_video' => MemberSeason(
                              seasonId: item.seasonId ?? -1,
                              heroTag: widget.heroTag,
                            ),
                          'series' => MemberSeries(
                              seriesId: item.seriesId ?? -1,
                              heroTag: widget.heroTag,
                            ),
                          _ => Center(child: Text(item.title!))
                        },
                      )
                      .toList(),
                ),
              ),
            ],
          )
        : Center(
            child: Text('视频'),
          );
  }
}
