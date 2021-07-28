//
//  ContentView.swift
//  iPlace
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 28.07.2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var placeManager = PlaceManager()
    @State var showDetail = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(placeManager.places) { place in
                    HStack(spacing: 10) {
                        Image(uiImage: UIImage(data: place.image)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .fontWeight(.semibold)
                                .font(.system(size: 19))
                            Text(place.location ?? "")
                                .font(.system(size: 17))
                            Text(place.type ?? "")
                                .font(.system(size: 13))
                        }
                    }
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
        ContentView()
    }
}
