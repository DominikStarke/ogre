# Ogre

![Mighty Ogre](assets/app_icon.png)

### AI for your Clipboard
Ogre provides a simple chat interface as tray-application.
Copy something to your clipboard and press ```shift + home```.

### Demo
[https://github.com/user-attachments/assets/2e2904f9-ad0c-469b-a5b5-52d482631c5f](https://github.com/user-attachments/assets/01913f44-8885-40e5-b1df-079a0b14a8ba)

[https://github.com/user-attachments/assets/7fea33f2-b56e-46ef-aa5f-5a73a73c6f38](https://github.com/user-attachments/assets/7fea33f2-b56e-46ef-aa5f-5a73a73c6f38)

### Setup
The following api providers are supported:
* openwebui
* openAI
* ollama
* anthropic  

Clone the repository and its 3rd party dependency (flutter_ai_community):
```bash
git clone https://github.com/DominikStarke/ogre.git --recurse-submodules
``` 

Build the application...
```
flutter run -d ...
```

Once the app started go to settings and configure your AI provider.

<img width="40%" alt="ogre_select" src="https://github.com/user-attachments/assets/8c4f3157-d3b3-4c7b-a08e-7cc0137e4139" />
<img width="40%" alt="ogre_settings" src="https://github.com/user-attachments/assets/36bd61fe-a90c-455b-8140-c5e5f29ff5f6" />

If there's data present in the clipboard it will show up in the top left corner:  

<img width="40%" alt="ogre_chat" src="https://github.com/user-attachments/assets/f0195be9-c8d8-45b2-8b4e-126d67643e05" />

