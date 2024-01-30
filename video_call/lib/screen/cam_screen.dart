import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;
  int? uid;
  int? otherUid;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();
    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw '카메라 또는 마이크 권한이 없습니다.';
    }
    if (engine == null) {
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        const RtcEngineContext(
            appId: APP_ID,
            channelProfile: ChannelProfileType.channelProfileLiveBroadcasting),
      );
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            print('channel 입장.. : uid:${connection.localUid}');
            setState(() {
              uid = connection.localUid;
            });
          },
          onLeaveChannel: (connection, stats) {
            print("channel out");
            setState(() {
              uid = null;
            });
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            print('상대 입장. uid : $remoteUid');
            setState(() {
              otherUid = remoteUid;
            });
          },
          onUserOffline: (connection, remoteUid, reason) {
            print('상대가 채널에서 나갔습니다. uid : $uid');
            setState(() {
              otherUid = null;
            });
          },
        ),
      );
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo();
      await engine!.startPreview();
      await engine!.joinChannel(
        token: TEMP_TOKEN,
        channelId: CHANNEL_NAME,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Cam'),
      ),
      body: FutureBuilder<bool>(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      renderMainView(),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          color: Colors.grey,
                          height: 160,
                          width: 120,
                          child: renderSubView(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (engine != null) await engine!.leaveChannel();
                      Navigator.of(context).pop();
                    },
                    child: const Text('채널 나가기'),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget renderSubView() {
    if (uid != null) {
      // AgoraVideoView 위젯을 사용하면
      // 동영상을 화면에 보여주는 위젯을 구현할 수 있습니다.
      return AgoraVideoView(
        // VideoViewController를 매개변수로 입력해주면
        // 해당 컨트롤러가 제공해주는 동영상 정보를
        // AgoraVideoView 위젯을 통해 보여줄 수 있습니다.
        controller: VideoViewController(
          rtcEngine: engine!,

          // VideoCanvas에 0을 입력해서 내 영상을 보여줍니다.
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      // 아직 내가 채널에 접속하지 않았다면
      // 로딩 화면을 보여줍니다.
      return const CircularProgressIndicator();
    }
  }

  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
        // VideoViewController.remote 생성자를 이용하면
        // 상대방의 동영상을 AgoraVideoView 그려낼 수 있습니다.
        controller: VideoViewController.remote(
          rtcEngine: engine!,

          // uid에 상대방 ID를 입력해줍니다.
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    } else {
      // 상대가 아직 채널에 들어오지 않았다면
      // 대기 메시지를 보여줍니다.
      return const Center(
        child: Text(
          '다른 사용자가 입장할 때까지 대기해주세요.',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
