# BipTheGuy

## Overview
A fun SwiftUI app where users tap an image to "bip" it — triggering a squash/stretch animation and punch sound effect. Users can replace the default clown image with any photo from their library.

## Architecture
- Single-view SwiftUI app (`ContentView`)
- `PhotosUI` for native photo picker integration
- `AVFAudio` for sound playback via `AVAudioPlayer`
- `UserDefaults` for persisting the selected image between launches

## Key Patterns
- `@State` for all local view state (animation scale, selected photo, image, audio player)
- `PhotosPicker` bound to a `PhotosPickerItem?` with `.onChange` to load data via `Transferable`
- Spring animation (`interpolatingSpring`) for the squash/stretch effect on tap
- Image data saved as raw `Data` in `UserDefaults` for simple persistence

## Assets
- `clown` image set in Assets.xcassets — default tappable image
- `freesound_community-punch-41105.mp3` — punch sound bundled in the app target

## Build / Run
Open `BipTheGuy.xcodeproj` in Xcode and run on an iOS simulator or device.
