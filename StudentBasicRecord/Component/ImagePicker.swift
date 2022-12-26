//
//  ImagePicker.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  @Binding var imagePath: String?
  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      
      guard let provider = results.first?.itemProvider else { return }
     
      provider.loadFileRepresentation(forTypeIdentifier: "public.item") { (url, error) in
        if error != nil {
          print("error \(error!)");
        } else {
          if let url = url {
            self.parent.imagePath = url.absoluteString
            let filename = url.lastPathComponent;
            print(filename)
          }
        }
      }
      
      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { image, _ in
          self.parent.image = image as? UIImage
        }
      }
    }
  }
  
  static func storeImage(urlString: String, img:UIImage){
    let path = NSTemporaryDirectory().appending(UUID().uuidString)
    let url = URL(fileURLWithPath: path)
    
    let data = img.jpegData(compressionQuality: 0.5)
    try? data?.write(to: url)
    
    var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]
    if dict == nil {
      dict = [String:String]()
    }
    dict![urlString] = path
    UserDefaults.standard.set(dict, forKey: "ImageCache")
  }
  
  static func loadImage(urlString: String)-> UIImage? {
    if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] {
      if let path = dict[urlString] {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
          let img = UIImage(data: data)
         return img
        }
      }
    }
  
    return nil
    
  }
}
