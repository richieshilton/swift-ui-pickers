//
//  ImagePickerView.swift
//  ImagePicker
//
//  Created by Richie Shilton on 10/11/21.
//

import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    let onComplete: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: imagePickerConfiguration)
        controller.title = "Pick an image"
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
      
        private let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            guard let result = results.first else {
                return parent.onComplete(nil)
            }
            
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] object, error in
                self?.parent.onComplete(object as? UIImage)
            })
        }
        
        
    }
    
    
    private var imagePickerConfiguration: PHPickerConfiguration {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        configuration.preferredAssetRepresentationMode = .compatible
        return configuration
    }
}
