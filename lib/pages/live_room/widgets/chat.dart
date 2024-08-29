import 'dart:convert';
import 'dart:developer';

import 'package:PiliPalaX/http/live.dart';
import 'package:PiliPalaX/models/live/danmu_info.dart';
import 'package:PiliPalaX/services/loggeer.dart';
import 'package:PiliPalaX/tcp/live.dart';
import 'package:flutter/material.dart';

import '../../../utils/storage.dart';

class LiveRoomChat extends StatefulWidget {
  final int roomId;
  const LiveRoomChat({super.key,required this.roomId});
  @override
  State<LiveRoomChat> createState() => _LiveRoomChatState();
}
class _LiveRoomChatState extends State<LiveRoomChat> {
  String dm="Danmaku Area";
  final List<Widget> _items = [];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (ctx,i){
      return _items[i];
    });//Center(child: Text(dm,style: const TextStyle(color: Colors.red),),);
  }
  late LiveMessageStream msgStream;
  @override
  void initState() {
    // TODO: implement initState
    LiveHttp.liveRoomGetDanmakuToken(roomId: widget.roomId).then((v){
      if (v['status']){
        LiveDanmakuInfo info=v['data'];
        logger.d("info => $info");
        msgStream=LiveMessageStream(streamToken: info.data.token, roomId: widget.roomId, uid: GStorage.userInfo.get('userInfoCache').mid??0, host: info.data.hostList[0].host, port: info.data.hostList[0].port);
        msgStream.addEventListener((obj){
          if(obj['cmd']=='DANMU_MSG'){
            logger.i(' 原始弹幕消息 ======> ${jsonEncode(obj)}');
            setState(() {
              var widget=Container(decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
                child: ListTile(
                  leading: obj['info'][0][15]['user']['medal']!=null?
                  Container(width: 70,height: 20,color: Color((0xff000000+obj['info'][0][15]['user']['medal']['color']) as int),
                    child:Center(
                      child: Text('${obj['info'][0][15]['user']['medal']['name']} '
                          'lv${obj['info'][0][15]['user']['medal']['level']}',style: const TextStyle(color: Color(0xffdddddd)),),)
                  ):const SizedBox(width: 70,height: 20,),
                  style: ListTileStyle.list,title: Text("${obj['info'][0][15]['user']['base']['name']}: ${obj['info'][1]}",style: const TextStyle(color: Color(0xffaaaaaa)),),),
              );
              _items.add(widget);
              if(_items.length>=20){
                _items.removeAt(0);
              }
            });
          }
        });
        msgStream.init();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    msgStream.close();
    super.dispose();
  }

}



final PiliLogger logger=getLogger();
