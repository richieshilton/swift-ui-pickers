//
//  ContentView.swift
//  ImagePicker
//
//  Created by Richie Shilton on 10/11/21.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    // View states
    @State private var image: Image?
    @State private var fileLocation: String?
    @State private var noAccessMessage: String?
    
    // Sheet states
    @State private var showingActionSheet = false
    @State private var showingCameraPicker = false
    @State private var showingImagePicker = false
    @State private var showingFilePicker = false
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            }
            
            if let fileLocation = fileLocation {
                Text(fileLocation)
                    .padding()
            }
            
            Button("Select") {
                showingActionSheet = true
            }
            .padding()
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Add a file"), buttons: [
                    .default(Text("Take a photo"), action: cameraButtonTapped),
                    .default(Text("Choose from Photo Library"), action: photosButtonTapped),
                    .default(Text("Choose from Files"), action: filesButtonTapped),
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $showingCameraPicker) {
                CameraPickerView { image in
                    use(image: image)
                    showingCameraPicker = false
                }
            }
            .fullScreenCover(isPresented: $showingImagePicker) {
                ImagePickerView { image in
                    use(image: image)
                    showingImagePicker = false
                }
            }
            .fullScreenCover(isPresented: $showingFilePicker) {
                FilePickerView { urls in
                    image = nil
                    if let url = urls.first?.absoluteString {
                        fileLocation = "The file is located at:\n\(url)"
                    }
                    showingFilePicker = false
                }
            }
            
            if image != nil || fileLocation != nil {
                Button("Remove file") {
                    image = nil
                    fileLocation = nil
                }
                .foregroundColor(.red)
                .padding()
            }
            
            if let message = noAccessMessage {
                Text(message)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
    }
    
    private func photosButtonTapped() {
        showingImagePicker = true
    }
    
    private func cameraButtonTapped() {
        AVCaptureDevice.authorizeCamera { status in
            switch status {
            case .authorized: showingCameraPicker = true
            default: noAccessMessage = "Go to settings to enable camera access"
            }
        }
    }
    
    private func filesButtonTapped() {
        showingFilePicker = true
    }
    
    private func use(image: UIImage?) {
        fileLocation = nil
        guard let image = image else { return }
        self.image = Image(uiImage: image)
    }
}
