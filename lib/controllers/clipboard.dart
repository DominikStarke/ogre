import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:mime/mime.dart';
import 'package:pasteboard/pasteboard.dart';

class ClipboardController extends ChangeNotifier {
  final List<String> _texts = [];
  final List<String> _files = [];
  final List<Uint8List> _images = [];

  final List<String> whiteListMimes = [
    'text/plain',
    'image/jpeg',
    'image/png',
  ];

  ClipboardController();

  List<Attachment> get texts {
    return _texts.map((t) => FileAttachment(
      name: 'clipboardText',
      mimeType: 'text/plain',
      bytes: Uint8List.fromList(utf8.encode(t)),
    )).toList();
  }

  List<Attachment> get images {
    return _images.map((img) => FileAttachment(
      name: 'clipboardImage',
      mimeType: 'image/jpeg',
      bytes: img,
    )).toList();
  }

  List<Attachment> get files {
    final files = _files.map((path) {
      File file = File(path);
      if (file.existsSync()) {
        return FileAttachment.fileOrImage(
          name: file.path.split('/').last,
          mimeType: lookupMimeType(path) ?? '',
          bytes: file.readAsBytesSync(),
        );
      } else {
        return null;
      }
    }).toList();
    files.removeWhere((file) => file == null);
    return files.cast<Attachment>();
  }

  void clear() {
    _texts.clear();
    _files.clear();
    _images.clear();
    notifyListeners();
  }

  void addAll({
    List<String>? text,
    List<String>? files,
    List<Uint8List>? image,
  }) {
    _texts.addAll(text ?? []);
    _files.addAll(files ?? []);
    _images.addAll(image ?? []);
    notifyListeners();
  }

  update() async {
    clear();
    final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    final image = await Pasteboard.image;
    final files = await Pasteboard.files();
    addAll(
      text: [if(text != null && files.isEmpty && image == null) text],
      image: [if(image != null) image],
      files: await Pasteboard.files()
    );
    notifyListeners();
  }
}
