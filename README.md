# Ogre

![Mighty Ogre](assets/app_icon.png)

### Fast ai access
Ogre provides a simple chat interface as tray-application.
Select some Text and press ```shift + home```.

It will then copy the text and attach the contents to your next chat request.

If a file is uploaded copying of the clipboard is skipped.

### Demo
https://github.com/user-attachments/assets/2e2904f9-ad0c-469b-a5b5-52d482631c5f

### Setup
As of now only openwebui is supported as endpoint.

Clone the repository and its 3rd party dependency (flutter_ai_community):
```bash
git clone https://github.com/DominikStarke/ogre.git --recurse-submodules
``` 
Create a .env file in the project root
```
OPENWEBUI_API_KEY=YOU_API_KEY_HERE
```

Build the application...
```
flutter run -d ...
```