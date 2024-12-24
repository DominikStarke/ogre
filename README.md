# Ogre

![Mighty Ogre](assets/app_icon.png)

### AI on your Desktop
Ogre provides a simple chat interface as tray-application.
Select some Text and press ```shift + home```.

It will then copy the text and attach the contents to your next chat request.

If a file is uploaded copying of the clipboard is skipped.

### Demo
https://github.com/user-attachments/assets/2e2904f9-ad0c-469b-a5b5-52d482631c5f

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

