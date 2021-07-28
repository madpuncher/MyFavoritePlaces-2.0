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
    
    @State var namePlace = ""
    @State var locationPlace = ""
    @State var typePlace = ""
    @State var showImage: UIImage?
    
    var place: Place?
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    if place == nil {
                        if showImage == nil {
                        Image("imagePlaceholder")
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .background(Color.gray)
                            .listRowInsets(EdgeInsets())
                            .onTapGesture {
                                showPhoto.toggle()
                            }
                        } else {
                            Image(uiImage: showImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: 250)
                                .clipped()
                                .listRowInsets(EdgeInsets())
                                .onTapGesture {
                                    showPhoto.toggle()
                                }
                        }
                    } else {
                        Image(uiImage: showImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            .clipped()
                            .listRowInsets(EdgeInsets())
                            .onTapGesture {
                                showPhoto.toggle()
                            }
                    }

                }
                .listRowInsets(EdgeInsets())
                
                if place == nil {
                    
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
                } else {
                    VStack(alignment: .leading) {
                        Text("Name")
                            .foregroundColor(.gray)
                        TextField("Place name", text: $namePlace)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Location")
                            .foregroundColor(.gray)
                        TextField("Place location", text: $locationPlace)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Type")
                            .foregroundColor(.gray)
                        TextField("Place type", text: $typePlace)
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 70)
            .navigationBarItems(
                leading: cancellButton,
                trailing: saveButton)
            .listStyle(PlainListStyle())
            .navigationBarTitle(place == nil ? "New Place" : place!.name)
            .navigationBarTitleDisplayMode(place == nil ? .inline : .large)
            .sheet(isPresented: $showPhoto, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .preferredColorScheme(.light)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        showImage = inputImage
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
        if place == nil {
       return Button(action: {
            placeManager.addNewObject()
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
                .foregroundColor(placeManager.placeName.isEmpty ? .gray : .black)
        }).disabled(placeManager.placeName.isEmpty)
        } else {
            return Button(action: {
                placeManager.placeName = namePlace
                placeManager.placeLocation = locationPlace
                placeManager.placeType = typePlace
                placeManager.image = showImage
                placeManager.editPlace(object: place!)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
                    .foregroundColor(namePlace.isEmpty ? .gray : .black)
            }).disabled(namePlace.isEmpty)
        }
    }
    
    //MARK CANCEL BUTTON
    private var cancellButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            placeManager.placeName = ""
            placeManager.placeLocation = ""
            placeManager.placeType = ""
            placeManager.image = nil
        }, label: {
            if place == nil {
                Text("Cancel")
                    .foregroundColor(.black)
            } else {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
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
