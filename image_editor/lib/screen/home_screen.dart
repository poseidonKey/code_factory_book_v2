import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;
  Set<StickerModel> stickers = {};
  String? selectedId;
  GlobalKey imgKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          renderBody(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MainAppBar(
                onPickImage: onPickImage,
                onSaveImage: onSaveImage,
                onDeleteItem: onDeleteItem),
          ),
          if (image != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Footer(onEmotionTap: onEmotionTap),
            )
        ],
      ),
    );
  }

  void onEmotionTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: const Uuid().v4(),
          imgPath: 'asset/img/emoticon_$index.png',
        )
      };
    });
  }

  Widget renderBody() {
    if (image != null) {
      return RepaintBoundary(
        key: imgKey,
        child: Positioned.fill(
          child: InteractiveViewer(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,
                ),
                ...stickers.map(
                  (e) => Center(
                    child: EmotionSticker(
                      key: ObjectKey(
                        e.id,
                      ),
                      onTransform: () {
                        onTransform(e.id);
                      },
                      imagePath: e.imgPath,
                      isSelected: selectedId == e.id,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          onPressed: onPickImage,
          child: const Text('image choice'),
        ),
      );
    }
  }

  void onDeleteItem() async {
    setState(() {
      stickers = stickers.where((element) => element.id != selectedId).toSet();
    });
  }

  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = image;
    });
  }

  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }

  void onSaveImage() async {
    RenderRepaintBoundary boundary =
        imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    await ImageGallerySaver.saveImage(pngBytes, quality: 100);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('save Completed'),
      ),
    );
  }
}
