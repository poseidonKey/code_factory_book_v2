import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: video == null
          ? renderEmpty()
          : Center(
              child: renderVideo(),
            ),
    );
  }

  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  Widget renderEmpty() {
    return Container(
      decoration: getBoxDecoration(),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ),
          const SizedBox(
            height: 30,
          ),
          const _AppName(),
        ],
      ),
    );
  }

  BoxDecoration getBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(colors: [
        Color(0xff2a3a7c),
        Color(0xff000118),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    );
  }

  Widget renderVideo() {
    return CustomVideoPlayer(
      video: video!,
      onNewVideoPressed: onNewVideoPressed,
    );
  }
}

class _Logo extends StatelessWidget {
  final GestureTapCallback onTap;
  const _Logo({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'asset/img/logo.png',
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w300,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Video',
          style: textStyle,
        ),
        Text(
          'PLAYER',
          style: textStyle.copyWith(
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
