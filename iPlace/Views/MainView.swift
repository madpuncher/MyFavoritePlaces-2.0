//
//  ContentView.swift
//  iPlace
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 28.07.2021.
//

import SwiftUI

struct MainView: View {
    @StateObject var placeManager = PlaceManager()
    @State var showDetail = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(placeManager.places) { place in
                    NavigationLink(
                        destination: AddPlaceView(placeManager: placeManager, namePlace: place.name, locationPlace: place.location ?? "", typePlace: place.type ?? "", showImage: UIImage(data: place.image), place: place).navigationBarHidden(true),
                        label: {
                            HStack(spacing: 10) {
                                Image(uiImage: UIImage(data: place.image)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                VStack(alignment: .leading) {
                                    Text(place.name)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 18))
                                    Text(place.location ?? "")
                                        .font(.system(size: 16))
                                    Text(place.type ?? "")
                                        .font(.system(size: 13))
                                }
                            }
                        })
                    
                }
                .onDelete(perform: { indexSet in
                    placeManager.deleteObject(index: indexSet)
                })
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(
                trailing:
                    Button(action: {
                        showDetail.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }))
            .navigationBarTitle("Favorite Places")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $showDetail, content: {
            AddPlaceView(placeManager: placeManager)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
