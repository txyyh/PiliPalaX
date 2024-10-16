import 'package:PiliPalaX/common/constants.dart';
import 'package:PiliPalaX/common/widgets/http_error.dart';
import 'package:PiliPalaX/common/widgets/network_img_layer.dart';
import 'package:PiliPalaX/http/loading_state.dart';
import 'package:PiliPalaX/pages/member/new/content/member_contribute/content/favorite/member_favorite_ctr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberFavorite extends StatefulWidget {
  const MemberFavorite({
    super.key,
    required this.heroTag,
    required this.mid,
  });

  final String? heroTag;
  final int mid;

  @override
  State<MemberFavorite> createState() => _MemberFavoriteState();
}

class _MemberFavoriteState extends State<MemberFavorite>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _controller = Get.put(
    MemberFavoriteCtr(mid: widget.mid),
    tag: widget.heroTag,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => _buildBody(_controller.loadingState.value));
  }

  _buildBody(LoadingState loadingState) {
    return loadingState is Success
        ? RefreshIndicator(
            onRefresh: () async {
              await _controller.onRefresh();
            },
            child: ListView.builder(
              itemCount: loadingState.response.length,
              itemBuilder: (_, index) {
                dynamic item = loadingState.response[index];
                return item.mediaListResponse.list is List
                    ? ExpansionTile(
                        dense: true,
                        title: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: item.name,
                                style: TextStyle(fontSize: 14),
                              ),
                              TextSpan(
                                text: ' ${item.mediaListResponse.count}',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        children: (item.mediaListResponse.list as List)
                            .map(
                              (item1) => ListTile(
                                onTap: () {
                                  if (item1.state == 1) {
                                    return;
                                  }
                                  if (item.id == 1) {
                                    Get.toNamed(
                                      '/favDetail',
                                      parameters: {
                                        'mediaId': item1.id.toString(),
                                        'heroTag': widget.heroTag ?? '',
                                      },
                                    );
                                  } else {
                                    // TODO
                                  }
                                },
                                leading: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: LayoutBuilder(
                                    builder: (_, constraints) =>
                                        NetworkImgLayer(
                                      radius: 6,
                                      src: item1.cover,
                                      width: constraints.maxHeight *
                                          StyleString.aspectRatio,
                                      height: constraints.maxHeight,
                                    ),
                                  ),
                                ),
                                title: Text(item1.title),
                                subtitle: Text(
                                  '${item1.mediaCount}个内容 · ${item1.mid == widget.mid ? [
                                      0,
                                      22
                                    ].contains(item1.attr) ? '公开' : '私密' : item1.upper.name}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : const SizedBox.shrink();
              },
            ),
          )
        : loadingState is Error
            ? Center(
                child: CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    HttpError(
                      errMsg: loadingState.errMsg,
                      fn: _controller.onReload,
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
  }
}
