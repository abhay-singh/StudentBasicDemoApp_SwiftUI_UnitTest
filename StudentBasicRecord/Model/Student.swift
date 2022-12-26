//
//  Model.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import Foundation

struct Student:  Hashable, Codable {
  let name: String
  let imageUrl: String
  let mobileNumber: String
}

extension Student: Identifiable {
  
  var id: String { name + mobileNumber }
}
