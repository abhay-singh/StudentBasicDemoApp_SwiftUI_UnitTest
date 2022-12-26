//
//  StudentListViewModel.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import Combine
import Foundation

class StudentListViewModel: ObservableObject {
  
  private let viewModelFactory: ViewModelFactory
  private var cancellables = Set<AnyCancellable>()
  
  @Published var students: [Student]

  
  init(viewModelFactory: ViewModelFactory) {
    self.viewModelFactory = viewModelFactory
    students = viewModelFactory.studentList
    let studentList: [Student] = loadFromJSONFile("studentData.json")
    viewModelFactory.$studentList.sink { [weak self] in
      self?.students = $0
      self?.students.append(contentsOf: studentList)
    }
    .store(in: &cancellables)
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
