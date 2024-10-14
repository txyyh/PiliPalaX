import 'dart:math';

import 'package:PiliPalaX/common/widgets/dynamic_sliver_appbar.dart';
import 'package:PiliPalaX/http/loading_state.dart';
import 'package:PiliPalaX/pages/member/new/content/member_archive.dart';
import 'package:PiliPalaX/pages/member/new/content/member_dynamic.dart';
import 'package:PiliPalaX/pages/member/new/content/member_home.dart';
import 'package:PiliPalaX/pages/member/new/controller.dart';
import 'package:PiliPalaX/pages/member/new/widget/user_info_card.dart';
import 'package:PiliPalaX/pages/member/view.dart';
import 'package:PiliPalaX/utils/utils.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberPageNew extends StatefulWidget {
  const MemberPageNew({super.key});

  @override
  State<MemberPageNew> createState() => _MemberPageNewState();
}

class _MemberPageNewState extends State<MemberPageNew>
    with TickerProviderStateMixin {
  int? _mid;
  String? _heroTag;
  late final MemberControllerNew _userController;
  late final TabController _tabController = TabController(
    vsync: this,
    length: 3,
    initialIndex: 1,
  );
  late final _tabs =
      ['主页', '动态', '投稿'].map((title) => Tab(text: title)).toList();
  late double top;

  @override
  void initState() {
    super.initState();
    _mid = int.parse(Get.parameters['mid']!);
    _heroTag = Get.arguments['heroTag'] ?? Utils.makeHeroTag(_mid);
    _userController = Get.put(
      MemberControllerNew(mid: _mid),
      tag: _heroTag,
    );
    _userController.scrollController.addListener(() {
      _userController.scrollRatio.value =
          min(1.0, _userController.scrollController.offset.round() / 150);
    });
  }

  @override
  Widget build(BuildContext context) {
    top = MediaQuery.of(context).padding.top;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(
          () => RefreshIndicator(
            onRefresh: () async {},
            child: _userController.loadingState.value is Success
                ? ExtendedNestedScrollView(
                    controller: _userController.scrollController,
                    onlyOneScrollInBody: true,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverOverlapAbsorber(
                          handle: ExtendedNestedScrollView
                              .sliverOverlapAbsorberHandleFor(context),
                          sliver: DynamicSliverAppBar(
                            leading: Padding(
                              padding: EdgeInsets.only(top: top),
                              child: const BackButton(),
                            ),
                            title: Obx(() =>
                                _userController.scrollRatio.value == 1 &&
                                        _userController.username != null
                                    ? Padding(
                                        padding: EdgeInsets.only(top: top),
                                        child: Text(_userController.username!),
                                      )
                                    : const SizedBox.shrink()),
                            pinned: true,
                            scrolledUnderElevation: 0,
                            flexibleSpace: _buildUserInfo(
                                _userController.loadingState.value),
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(48),
                              child: Material(
                                child: TabBar(
                                  controller: _tabController,
                                  tabs: _tabs,
                                  // onTap: (index) {
                                  //   if (!_tabController.indexIsChanging) {
                                  //     _returnTopController.setIndex(index);
                                  //   }
                                  // },
                                ),
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: EdgeInsets.only(top: top),
                                child: IconButton(
                                  tooltip: '搜索',
                                  onPressed: () => Get.toNamed(
                                      '/memberSearch?mid=$_mid&uname=${_userController.username}'),
                                  icon: const Icon(Icons.search_outlined),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: top),
                                child: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry>[
                                    if (_userController.ownerMid != _mid) ...[
                                      PopupMenuItem(
                                        onTap: () =>
                                            _userController.blockUser(context),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.block, size: 19),
                                            const SizedBox(width: 10),
                                            Text(_userController.relation != -1
                                                ? '加入黑名单'
                                                : '移除黑名单'),
                                          ],
                                        ),
                                      )
                                    ],
                                    PopupMenuItem(
                                      onTap: () => _userController.shareUser(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.share_outlined,
                                              size: 19),
                                          const SizedBox(width: 10),
                                          Text(_userController.ownerMid != _mid
                                              ? '分享UP主'
                                              : '分享我的主页'),
                                        ],
                                      ),
                                    ),
                                    if (_userController.ownerMid != null) ...[
                                      const PopupMenuDivider(),
                                      PopupMenuItem(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => AlertDialog(
                                              clipBehavior: Clip.hardEdge,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 16,
                                              ),
                                              content: ReportPanel(
                                                name: _userController.username,
                                                mid: _mid,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              size: 19,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '举报',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .error),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: LayoutBuilder(
                      builder: (context, _) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: ExtendedNestedScrollView
                                        .sliverOverlapAbsorberHandleFor(context)
                                    .layoutExtent ??
                                0,
                          ),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              MemberHome(),
                              MemberDynamic(),
                              MemberArchive(),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: _buildUserInfo(_userController.loadingState.value),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _errorWidget(msg) {
    return GestureDetector(
      onTap: () {
        _userController.loadingState.value = LoadingState.loading();
        _userController.onRefresh();
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        child: Text(msg),
      ),
    );
  }

  Widget _buildUserInfo(LoadingState userState) {
    switch (userState) {
      case Empty():
        return _errorWidget('EMPTY');
      case Error():
        return _errorWidget(userState.errMsg);
      case Success():
        return Obx(
          () => UserInfoCard(
            relation: _userController.relation,
            isFollow: _userController.isFollow.value,
            card: userState.response.card,
            images: userState.response.images,
            // onFollow: _userController.onFollow,
          ),
        );
    }
    return const CircularProgressIndicator();
  }
}
