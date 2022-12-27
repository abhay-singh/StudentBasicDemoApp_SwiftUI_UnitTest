//
//  StudentBasicRecordApp.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import SwiftUI

@main
struct StudentBasicRecordApp: App {
  let viewModelFactory = ViewModelFactory()
    var body: some Scene {
        WindowGroup {
          NewStudentView()
            // Here we inject the ReadingListController instance in the
            // environment
            .environmentObject(viewModelFactory)
        }
    }
}
