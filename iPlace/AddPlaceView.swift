//
//  AddPlaceView.swift
//  iPlace
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 28.07.2021.
//

import SwiftUI

struct AddPlaceView: View {
    @ObservedObject var placeManager: PlaceManager
    @State var showPhoto = false
    @State private var inputImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            List {
                if placeManager.image == nil {
                Image("imagePlaceholder")
                    .frame(width: UIScreen.main.bounds.width, height: 250)
                    .background(Color.gray)
                    .ignoresSafeArea()
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        showPhoto.toggle()
                    }
                } else {
                    placeManager.showImage!
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 250)
                        .background(Color.gray)
                        .ignoresSafeArea()
                        .listRowInsets(EdgeInsets())
                        .onTapGesture {
                            showPhoto.toggle()
                        }
                }
                
                VStack(alignment: .leading) {
                    Text("Name")
                        .foregroundColor(.gray)
                    TextField("Place name", text: $placeManager.placeName)
                }
                
                VStack(alignment: .leading) {
                    Text("Location")
                        .foregroundColor(.gray)
                    TextField("Place location", text: $placeManager.placeLocation)
                }
                
                VStack(alignment: .leading) {
                    Text("Type")
                        .foregroundColor(.gray)
                    TextField("Place type", text: $placeManager.placeType)
                }
            }
            .environment(\.defaultMinListRowHeight, 70)
            .navigationBarItems(
                leading: cancellButton,
                trailing: saveButton)
            .listStyle(PlainListStyle())
            .navigationBarTitle("New Place")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPhoto, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .preferredColorScheme(.light)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        placeManager.showImage = Image(uiImage: inputImage)
        placeManager.image = inputImage
    }
}


struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView(placeManager: PlaceManager())
    }
}

extension AddPlaceView {
    //MARK SAVE BUTTON
    private var saveButton: some View {
        Button(action: {
            placeManager.addNewObject()
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
                .foregroundColor(.black)
        }).disabled(placeManager.placeName.isEmpty)
    }
    
    //MARK CANCEL BUTTON
    private var cancellButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
                .foregroundColor(.black)
        })
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) ->  UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
