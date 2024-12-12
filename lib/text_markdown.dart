import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:ogre/text_markdown_selectable_adapter.dart';

String latexWorkaround (tex) {
  List<String> stack = [];
  tex = tex.splitMapJoin(
    RegExp(r"\\text\{|\{|\}|\_"),
    onMatch: (p) {
      String input = p[0] ?? "";
      if (input == r"\text{") {
        stack.add(input);
      }
      if (stack.isNotEmpty) {
        if (input == r"{") {
          stack.add(input);
        }
        if (input == r"}") {
          stack.removeLast();
        }
        if (input == r"_") {
          return r"\_";
        }
      }
      return input;
    },
  );
  return tex.replaceAllMapped(
      RegExp(r"align\*"),
      (match) => "aligned");
}

Widget latexBuilder (context, tex, textStyle, inline) {
  if (tex.contains(r"\begin{tabular}")) {
    // return table.
    String tableString = "|${(RegExp(
          r"^\\begin\{tabular\}\{.*?\}(.*?)\\end\{tabular\}$",
          multiLine: true,
          dotAll: true,
        ).firstMatch(tex)?[1] ?? "").trim()}|";
    tableString = tableString
        .replaceAll(r"\\", "|\n|")
        .replaceAll(r"\hline", "")
        .replaceAll(
            RegExp(r"(?<!\\)&"), "|");
    var tableStringList = tableString
        .split("\n")
      ..insert(1, "|---|");
    tableString =
        tableStringList.join("\n");
    return TexMarkdown(tableString);
  }
  var controller = ScrollController();
  Widget child = Math.tex(
    tex,
    textStyle: textStyle,
  );
  if (!inline) {
    child = Padding(
      padding: const EdgeInsets.all(0.0),
      child: Material(
        color: Theme.of(context)
            .colorScheme
            .onInverseSurface,
        child: Padding(
          padding:
              const EdgeInsets.all(8.0),
          child: Scrollbar(
            controller: controller,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection:
                  Axis.horizontal,
              child: Math.tex(
                tex,
                textStyle: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
  child = SelectableAdapter(
    selectedText: tex,
    child: Math.tex(tex),
  );
  child = InkWell(
    onTap: () {
      debugPrint("Hello world");
    },
    child: child,
  );
  return child;
}

Widget sourceTagBuilder (buildContext, string, textStyle) {
  var value = int.tryParse(string);
  value ??= -1;
  value += 1;
  return SizedBox(
    height: 20,
    width: 20,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius:
            BorderRadius.circular(10),
      ),
      child:
          Center(child: Text("$value")),
    ),
  );
}
