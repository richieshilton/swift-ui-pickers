//
//  DocumentPickerView.swift
//  ImagePicker
//
//  Created by Richie Shilton on 10/11/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePickerView: UIViewControllerRepresentable {
    
    var onComplete: ([URL]) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        let types = [.image, .pdf, UTType(filenameExtension: "doc")].compactMap { $0 }
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ presentingController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        private var parent: FilePickerView
        
        init(_ parent: FilePickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onComplete(urls)
        }
    }
}
