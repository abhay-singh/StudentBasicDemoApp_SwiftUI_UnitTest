//
//  StudentBasicRecordTests.swift
//  StudentBasicRecordTests
//
//  Created by R Systems on 12/26/22.
//

import XCTest

class StudentBasicRecordTests: XCTestCase {
  private var vm:NewStudentViewModel!
  private var vmf:ViewModelFactory!
  
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      vmf = ViewModelFactory()
      vm = NewStudentViewModel(viewModelFactory: vmf)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      vm = nil
      vmf = nil
    }

  func test_studentBasicRecordInputValidationAllRecord()  {
    vm.validateAllReuiredField(name: "Abhay Kumar Singh", mobileNumber: "8376838859", imageUrl: "file//skjddakjfhdjf", uiimage: UIImage()) { flag, message in
      let actual = message
      let expected = "Valid"
      XCTAssertEqual(expected, actual)
  
      
    }
  }
  
  func test_studentBasicRecordInputNameErrorMessage()  {
    vm.validateAllReuiredField(name: "", mobileNumber: "", imageUrl: "", uiimage: nil) { flag, message in
      let actual = message
      let expected = "Please Enter Student Name"
      XCTAssertEqual(expected, actual)
      
      
    }
  }
  
  func test_studentBasicRecordInputMobileNumberErrorMessage()  {
    vm.validateAllReuiredField(name: "Abhay Singh", mobileNumber: "", imageUrl: "", uiimage: nil) { flag, message in
      let actual = message
      let expected = "Please Enter Student Mobile Number"
      XCTAssertEqual(expected, actual)
      
      
    }
  }
  
  func test_studentBasicRecordInputValidationOfPhoto()  {
    vm.validateAllReuiredField(name: "Abhay", mobileNumber: "8376838859", imageUrl: "", uiimage: nil) { flag, message in
      let actual = message
      let expected = "Please Select Student Photo"
      XCTAssertEqual(expected, actual)
      
      
    }
  }

}
