//
//  StudentListView.swift
//  StudentBasicRecord
//
//  Created by Abhay Kumar Singh on 12/26/22.
//

import SwiftUI

struct URLImage: View {
  let urlString: String
  @State var data: Data?
  let apiManager = APIManager()
  var body: some View {
    
    if let img = ImagePicker.loadImage(urlString: urlString){
      Image(uiImage: img)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 130, height: 70)
        .background(Color.gray)

    } else if let data = data, let uiimage = UIImage(data: data) {

      Image(uiImage: uiimage)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 130, height: 70)
        .background(Color.gray)

    } else {
      Image(systemName: "Profile")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 130, height: 70)
        .background(Color.gray)
        .onAppear{
          apiManager.downloadContent(fromUrlString: urlString, completionHandler: { (result) in
            switch result {
              case .success(let imageData):
                  // handle data
                data = imageData
                break
              case .failure(let error):
                debugPrint(error.localizedDescription)
            }
          })
        }
    }
  }
}

struct StudentListView: View {
  @EnvironmentObject var viewModelFactory: ViewModelFactory
  
    var body: some View {
      NavigationView{
        List(viewModelFactory.studentList) { student in
          HStack{
            URLImage(urlString: student.imageUrl)
            VStack(alignment: .leading) {
              Text(student.name).bold()
              Text(student.mobileNumber).bold()
            }
            .padding(2)
          }
        }
        .navigationTitle("Students")
      }.onAppear {
        
      }
    }
}

struct StudentListView_Previews: PreviewProvider {
    static var previews: some View {
      StudentListView()
    }
}
