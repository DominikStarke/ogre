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
    return _images.map((img) => ImageFileAttachment(
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
    }).toList()..removeWhere((file) => file == null);
    return files.cast<Attachment>();
  }

  void clear() {
    _texts.clear();
    _files.clear();
    _images.clear();
    Clipboard.setData(const ClipboardData(text: ''));
    notifyListeners();
  }

  void _addUniqueItems<T>(List<T> source, List<T> target) {
    for (var item in source) {
      if (!target.contains(item)) {
        target.add(item);
      }
    }
  }

  void addAll({
    List<String>? texts,
    List<String>? files,
    List<Uint8List>? images,
  }) {
    if (texts != null) {
      _addUniqueItems(texts, _texts);
    }

    if (files != null) {
      _addUniqueItems(files, _files);
    }

    if (images != null) {
      _addUniqueItems(images, _images);
    }

    notifyListeners();
  }

  Future<void> update() async {
    final text = (await Clipboard.getData(Clipboard.kTextPlain))?.text?.trim();
    final image = await Pasteboard.image;
    final files = await Pasteboard.files();
    addAll(
      texts: [if(text != null && text.isNotEmpty && files.isEmpty && image == null) text],
      images: [if(image != null && files.isEmpty) image],
      files: await Pasteboard.files()
    );
    notifyListeners();
  }
}
