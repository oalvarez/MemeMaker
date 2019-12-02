# MemeMaker
Meme maker as an interview test For Wizars Lab

##Functionalities
1. Import a video from the Photos app
2. Edit a text that appears in screen
3. Get a new video or Compose the current video with the overlay text
4. Show progress of the composition and allows to cancel it
5. Save to Roll

##App Arquitecture
- **PlayerKit:** Library that constructs the player
	- PlayerView
	- ControlsView with Play button
	- Extension to setup the views
	- Some extension to organize the code
- **ComposerKit:** Library that takes care of composition of the video and the text. Following methods should be exposed to controller
	- composeVideo 
	- createTextLayerForVideo  
	- cancelExport
- **Helpers for auto layout and styling**
- **MemeBuilder:** Main View Controller. Extension as helpers to:
	- Import video
	- Setup views
	- Prepare the player
	- Create configuration for composer

##Next Steps
1. Rework libraries, using protocols to expose the needed functions
2. Convert the libraries into Swift Packages
3. Add tests for libraries and for the main application
4. Improve the UI/UX
