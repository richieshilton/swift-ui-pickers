//
//  AVCaptureDevice+Extensions.swift
//  ImagePicker
//
//  Created by Richie Shilton on 10/11/21.
//

import AVFoundation

extension AVCaptureDevice {
    
    enum AuthorizationStatus {
        case denied
        case restricted
        case authorized
        case unknown
    }
    
    class func authorizeCamera(completion: ((AuthorizationStatus) -> Void)?) {
        AVCaptureDevice.authorize(mediaType: .video, completion: completion)
    }
    
    private class func authorize(mediaType: AVMediaType, completion: ((AuthorizationStatus) -> Void)?) {
        
        switch AVCaptureDevice.authorizationStatus(for: mediaType) {
        case .authorized: completion?(.authorized)
        case .denied: completion?(.denied)
        case .restricted: completion?(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        completion?(.authorized)
                    } else {
                        completion?(.denied)
                    }
                }
            })
        @unknown default: completion?(.unknown)
        }
    }
}
