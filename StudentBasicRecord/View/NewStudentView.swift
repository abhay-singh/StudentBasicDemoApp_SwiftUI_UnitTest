//
//  ContentView.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import SwiftUI

struct NewStudentView: View {
  @EnvironmentObject var viewModelFactory: ViewModelFactory
  @StateObject private var vm = NewStudentViewModel()
  @State private var image: Image?
  @State private var inputImage: UIImage?
  @State var imagePath: String?
  @State private var showingAlert = false
  @State private var showingAlertMessage = ""

  private let apiManager = APIManager()
  
    var body: some View {
      NavigationView {
        Form {
          VStack(alignment: .center, spacing: 20) {
            HStack{
              ZStack {
                Rectangle().fill(.secondary)
                Text("Tap to select a picture")
                  .foregroundColor(.white)
                  image?
                  .resizable()
                  .scaledToFit()
              }.frame(width: 150, height: 150, alignment: .leading)
                .onTapGesture {
                  vm.showingImagePicker = true
                }
              Text("Student Profile Image")
              Spacer()
            }
           
            VStack(alignment: .leading, spacing: 10) {
              Text("Student Name")
                .font(.headline)
              TextField("Name:", text: $vm.name)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.alphabet)
                .submitLabel(.done)
            }
            
            VStack(alignment: .leading, spacing: 10) {
              Text("Student Mobile Number")
                .font(.headline)
              TextField("Mobile Number:", text: $vm.mobileNumber)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.namePhonePad)
                .submitLabel(.done)
            }
            
          }.padding()

          Button(action: {
            print("Name Value \(vm.name)", "Mobile Number \(vm.mobileNumber)", "Image \(String(describing: vm.imagePath))")
             vm.validateAndSaveData(uiimage: self.inputImage,
                                  completion: { flag, message in
               if flag == false {
                 showingAlertMessage = message
                 showingAlert = true
               }else {
                 showingAlert = false
                 viewModelFactory.add(Student(name: vm.name, imageUrl: vm.imagePath!, mobileNumber: vm.mobileNumber))
               }
            })
          }, label: {
            Image(systemName: "plus")
          })
          .background(
            NavigationLink(
              "Student", destination: StudentListView(),
              isActive:$vm.showDetails
            )
          )
          .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Required detail"), message: Text(showingAlertMessage), dismissButton: .default(Text("OK")))
          })
          
        }.navigationTitle("Student New Record")
          .onChange(of: inputImage) { _ in
            loadImage()
          }.sheet(isPresented: $vm.showingImagePicker) {
            ImagePicker(image: $inputImage, imagePath: $imagePath)
         }
         
      }

    }
  
  func loadImage(){
    guard let inputImage = inputImage, let imagePath = imagePath else { return }
    image = Image(uiImage: inputImage)
    vm.imagePath = imagePath
    let cachedData = CachedURLResponse(response: URLResponse(url: URL(string: imagePath)!, mimeType: "image/png", expectedContentLength: 604800, textEncodingName: nil), data: inputImage.pngData()!)
    apiManager.cache.storeCachedResponse(cachedData, for: URLRequest(url: URL(string: imagePath)!))
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      NewStudentView()
    }
}
