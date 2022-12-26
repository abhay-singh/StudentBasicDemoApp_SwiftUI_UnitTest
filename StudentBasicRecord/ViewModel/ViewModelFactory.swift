//
//  ViewModelFactory.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import Combine
import Foundation

class ViewModelFactory: ObservableObject {
  @Published private(set) var studentList: [Student] = []

  func add(_ student: Student) {
    studentList.append(student)
  }
  
  func remove(_ student: Student) {
    studentList = studentList.filter { $0.name != student.name }
  }
  

}
