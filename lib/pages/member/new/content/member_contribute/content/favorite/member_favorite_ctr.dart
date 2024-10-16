import 'package:PiliPalaX/http/loading_state.dart';
import 'package:PiliPalaX/http/member.dart';
import 'package:PiliPalaX/pages/common/common_controller.dart';

class MemberFavoriteCtr extends CommonController {
  MemberFavoriteCtr({
    required this.mid,
  });

  final int mid;

  @override
  void onInit() {
    super.onInit();
    queryData();
  }

  @override
  bool customHandleResponse(Success response) {
    loadingState.value = response;
    return true;
  }

  @override
  Future<LoadingState> customGetData() => MemberHttp.spaceFav(mid: mid);
}
