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
  var dataFromLocalJSONFileLoaded = false
  
  func add(_ student: Student) {
    studentList.append(student)
    if dataFromLocalJSONFileLoaded == false {
      studentList.append(contentsOf: loadFromJSONFile("studentData.json") as [Student])
      dataFromLocalJSONFileLoaded = true
    }
  }
  
  func remove(_ student: Student) {
    studentList = studentList.filter { $0.name != student.name }
  }
  
  func loadFromJSONFile<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
      fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
      data = try Data(contentsOf: file)
    } catch {
      fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
  }

}
