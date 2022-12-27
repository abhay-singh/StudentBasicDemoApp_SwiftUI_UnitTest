//
//  ViewModel.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import Foundation
import SwiftUI

final class NewStudentViewModel: ObservableObject {
  var imagePath: String?
  @Published var name = ""
  @Published var mobileNumber = ""
  @Published var showingImagePicker: Bool
  @Published var showDetails: Bool

  init() {
    self.showingImagePicker = false
    self.showDetails = false
  }
  
  func saveStudentData(uiimage: UIImage?){
    self.hideKeyboard()
    if let img = uiimage, let imageUrl = imagePath {
      ImagePicker.storeImage(urlString: imageUrl, img: img)
    }
   
    self.showDetails = true
  }
  
  func validateAndSaveData(uiimage: UIImage?, completion: @escaping (_ flag: Bool, _ message: String)->Void){
    validateAllReuiredField(name: name, mobileNumber: mobileNumber, imageUrl: imagePath, uiimage: uiimage) { [weak self] flag, message in
      if flag {
        self?.saveStudentData(uiimage: uiimage)
      } else {
        self?.showDetails = false
      }
      completion(flag, message)
    }
  }
  
  func validateAllReuiredField(name: String, mobileNumber: String,
                               imageUrl:String?,
                               uiimage: UIImage?,
                               completion: @escaping (_ flag: Bool, _ message: String)->Void) {
    if validateName(name: name), validateMobileNumber(mobile: mobileNumber), (uiimage != nil), (imagePath != nil) {
      completion(true, "Valid")
    } else
    {
    if validateName(name: name) == false {
      completion(false, "Please Enter Student Name")
    } else if validateMobileNumber(mobile: mobileNumber) == false {
      completion(false, "Please Enter Student Mobile Number")
    } else if uiimage == nil ,imagePath == nil {
      completion(false, "Please Select Student Photo")
    }
      
    }
  }
  
  func validateName(name: String) ->  Bool {
    let STRING_ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        if name == "" {
          return false
        } else {
          let cs = NSCharacterSet(charactersIn: STRING_ACCEPTABLE_CHARACTERS).inverted
          let filtered = name.components(separatedBy: cs).joined(separator: " ")
          return (name == filtered)
        }
  }
  
  func validateMobileNumber(mobile: String) -> Bool {
      let PHONE_REGEX = "^[0-9]{6,14}$"
      let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
      let result =  phoneTest.evaluate(with: mobile)
      return result
  }
  
  private func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
}

