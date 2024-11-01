import 'package:PiliPalaX/http/loading_state.dart';
import 'package:PiliPalaX/models/live/danmu_info.dart';
import '../models/live/item.dart';
import '../models/live/room_info.dart';
import '../models/live/room_info_h5.dart';
import 'api.dart';
import 'init.dart';

class LiveHttp {
  static Future<LoadingState> liveList(
      {int? vmid, int? pn, int? ps, String? orderType}) async {
    var res = await Request().get(Api.liveList,
        data: {'page': pn, 'page_size': 30, 'platform': 'web'});
    if (res.data['code'] == 0) {
      List<LiveItemModel> list = res.data['data']['list']
          .map<LiveItemModel>((e) => LiveItemModel.fromJson(e))
          .toList();
      if (list.isNotEmpty) {
        return LoadingState.success(list);
      } else {
        return LoadingState.empty();
      }
    } else {
      return LoadingState.error(res.data['message']);
    }
  }

  static Future liveRoomInfo({roomId, qn}) async {
    var res = await Request().get(Api.liveRoomInfo, data: {
      'room_id': roomId,
      'protocol': '0, 1',
      'format': '0, 1, 2',
      'codec': '0, 1',
      'qn': qn,
      'platform': 'web',
      'ptype': 8,
      'dolby': 5,
      'panorama': 1,
    });
    if (res.data['code'] == 0) {
      return {'status': true, 'data': RoomInfoModel.fromJson(res.data['data'])};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomInfoH5({roomId, qn}) async {
    var res = await Request().get(Api.liveRoomInfoH5, data: {
      'room_id': roomId,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': RoomInfoH5Model.fromJson(res.data['data'])
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future liveRoomGetDanmakuToken({roomId})async{
    var res = await Request().get(Api.liveRoomDmToken, data: {
      'id': roomId,
    });
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': LiveDanmakuInfo.fromJson(res.data)
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
