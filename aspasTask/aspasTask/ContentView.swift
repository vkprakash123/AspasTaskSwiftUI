//
//  ContentView.swift
//  aspasTask
//
//  Created by Pavan manikanta on 18/05/23.
//

import SwiftUI
import CoreData
import CoreLocation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
    @State private var phoneNumber: String = ""
    @State private var firstName: String = ""
    @State private var selectedPhoto: UIImage? = nil
    @State private var showPhotoPicker: Bool = false
    
    @State private var currentStep: Int = 0
    

    
    

    var body: some View {
        VStack {
            if currentStep == 0 {
                PhoneNumberView(phoneNumber: $phoneNumber, onNext: moveToNextStep)
            } else if currentStep == 1 {
                FirstNameView(firstName: $firstName, onNext: moveToNextStep)
            } else if currentStep == 2 {
                PhotoSelectionView(selectedPhoto: $selectedPhoto, showPhotoPicker: $showPhotoPicker, onNext: saveData)
            }
        }
        .sheet(isPresented: $showPhotoPicker) {
            ImagePickerView(selectedImage: $selectedPhoto)
        }
    }
    
    private func moveToNextStep(){
        currentStep += 1
    }
    
    private func saveData(){
        guard let image = selectedPhoto, !phoneNumber.isEmpty, !firstName.isEmpty else {
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let newContact = Item(context: viewContext)
        newContact.phoneNumber = phoneNumber
        newContact.firstName = firstName
        newContact.photo = imageData
        newContact.longitude = 0.0
        newContact.latitude = 0.0
        
        do {
            try viewContext.save()
            print("Data saved Successfully")
        } catch {
            print("Failed to save data: \(error)")
        }
    }
}
        




struct PhoneNumberView: View {
    @Binding var phoneNumber: String
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Text("What's your phone number?")
                .font(Font.headline)
                .padding()
            Text("You'll get an OTP. Your number is not visible to others.")
                .foregroundColor(Color.gray)
            TextField("9884040857", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button(action: onNext){
                Text("Next")
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
            }
            .padding()
        }
    }
}









struct FirstNameView: View {
    @Binding var firstName: String
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                .padding()
            
            Button(action:onNext){
                                Text("Next")
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 40)
                                    .background(Color.black)
                                    .cornerRadius(15)
                                    .padding()
                            }
        }
    }
}






struct PhotoSelectionView: View {
    @Binding var selectedPhoto: UIImage?
    @Binding var showPhotoPicker: Bool
    var onNext: () -> Void
    var body: some View{
        VStack {
            if let photo = selectedPhoto {
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } else {
                Text("No Photo Selected")
                    .foregroundColor(.gray)
            }
            Button(action: {
                showPhotoPicker = true
            }) {
                Text("Select Photo")
            }
            .padding()
            
            Button(action: onNext){
                Text("Next")
            }
            .padding()
        }
    }
}



struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
