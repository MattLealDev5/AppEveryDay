//
//  ContentView.swift
//  BipTheGuy
//
//  Created by Matthew Leal on 3/10/26.
//

import SwiftUI
import PhotosUI
import AVFAudio

struct ContentView: View {
    @State private var animationAmount = 1.0
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var bipImage: Image?
    @State private var audioPlayer: AVAudioPlayer?

    // Key for saving image data to UserDefaults
    private let savedImageKey = "savedBipImage"

    var body: some View {
        VStack {
            Spacer()

            // Tappable image in the center
            bipImage(for: bipImage)
                .resizable()
                .scaledToFit()
                .scaleEffect(animationAmount)
                .padding(.horizontal)
                .onTapGesture {
                    playPunchSound()
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 12)) {
                        animationAmount = 0.8
                    }
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 12).delay(0.1)) {
                        animationAmount = 1.0
                    }
                }

            Spacer()

            // Photo picker button at the bottom
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                Label("Photo Library", systemImage: "photo.fill.on.rectangle.fill")
                    .font(.title2)
                    .padding()
            }
            .buttonStyle(.glassProminent)
            .padding(.bottom)
        }
        .task {
            loadSavedImage()
        }
        .onChange(of: selectedPhoto) { oldValue, newValue in
            Task {
                await loadSelectedPhoto(from: newValue)
            }
        }
    }

    /// Returns the user's chosen image, or the default clown image
    private func bipImage(for selectedImage: Image?) -> Image {
        if let selectedImage {
            return selectedImage
        }
        return Image("clown")
    }

    /// Plays the punch sound effect
    private func playPunchSound() {
        guard let soundURL = Bundle.main.url(forResource: "freesound_community-punch-41105", withExtension: "mp3") else {
            print("Could not find punch sound file.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }

    /// Loads the selected photo from the PhotosPicker
    private func loadSelectedPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    bipImage = Image(uiImage: uiImage)
                    saveImageData(data)
                }
            }
        } catch {
            print("Error loading photo: \(error.localizedDescription)")
        }
    }

    /// Saves image data to UserDefaults for persistence
    private func saveImageData(_ data: Data) {
        UserDefaults.standard.set(data, forKey: savedImageKey)
    }

    /// Loads the previously saved image from UserDefaults
    private func loadSavedImage() {
        guard let data = UserDefaults.standard.data(forKey: savedImageKey),
              let uiImage = UIImage(data: data) else {
            return
        }
        bipImage = Image(uiImage: uiImage)
    }
}

struct ClearSavedImage: PreviewModifier {
    func body(content: Content, context: Void) -> some View {
        content.onAppear {
            UserDefaults.standard.removeObject(forKey: "savedBipImage")
        }
    }
}

#Preview("BipTheGuy", traits: .sizeThatFitsLayout, .modifier(ClearSavedImage())) {
    ContentView()
}
