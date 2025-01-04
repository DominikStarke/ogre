import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:ogre/controllers/llm.dart';
import 'package:ogre/theme/material_chat.dart';
import 'package:ogre/widgets/app_menu.dart';
// import 'package:ogre/widgets/clipboard_menu.dart';

class OgreChat extends StatelessWidget {
  const OgreChat({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LlmController.of(context);
    
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: const AppMenu(), // ClipboardMenu(),
      body: ListenableBuilder(
        listenable: controller.configChanged,
        builder: (context, _) {
          return Row(
            children: [

              NavigationRail(
                labelType: NavigationRailLabelType.none,
                selectedIndex: 0,
                // groupAlignment: groupAlignment,
                onDestinationSelected: (int index) {
                  // setState(() {
                  //   _selectedIndex = index;
                  // });
                },
                // labelType: labelType,
                leading: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    controller.clearChat();
                  },
                  child: const Icon(Icons.add),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/settings");
                  },
                  icon: const Icon(Icons.settings_suggest_rounded),
                ),
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite_border),
                    selectedIcon: Icon(Icons.chat_bubble_outline_rounded),
                    label: Text('Chats'),
                  ),
                ],
              ),

              if(controller.isOpenWebUiProvider) Drawer(
                width: 210,
                child: ListenableBuilder(
                  listenable: controller.chatListChanged,
                  builder: (context, _) {
                    return ListView(
                      children: [
                        for(final chat in controller.chatList) ListTile(
                          title: Text(chat.title, overflow: TextOverflow.ellipsis,),
                          onTap: () {
                            controller.loadChat(chat);
                          },
                        ),
                      ],
                    );
                  }
                ),
              ),
          
              Expanded(
                child: ListenableBuilder(
                  listenable: controller.configChanged,
                  builder: (context, _) {
                    if(controller.llmProvider == null) {
                      return const Center(
                        child: Text("No provider selected. Go to settings and configure your AI provider.")
                      );
                    } else {
                      return LlmChatView(
                        messageSender: controller.clipboardAttachmentSender,
                        provider: controller.llmProvider!,
                        // responseBuilder: controller.responseBuilder,
                        style: materialChatThemeOf(context),
                      );
                    }
                  } 
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
