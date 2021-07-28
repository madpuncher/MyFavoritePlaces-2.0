//
//  PlaceManager.swift
//  iPlace
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 28.07.2021.
//

import RealmSwift
import SwiftUI

class PlaceManager: ObservableObject {
    
    @Published var places = [Place]()
    @Published var placeName = ""
    @Published var placeLocation = ""
    @Published var placeType = ""
    @Published var image: UIImage?
    
    
    init() {
        getDataFromDB()
    }
    
    //MARK: - Get data from realm
    private func getDataFromDB() {
        let results = realm.objects(Place.self)
            self.places = results.compactMap({ place in
                return place
            })
        
    }
    
    //MARK: - Append new object in data base
    func addNewObject() {
        let newPlace = Place()
        let imageData = image?.pngData() ?? UIImage(named: "imagePlaceholder")?.pngData()
        newPlace.name = placeName
        newPlace.location = placeLocation
        newPlace.type = placeType
        newPlace.rating = 0.0
        newPlace.image = imageData!
        StorageManager.addObject(newPlace)
        getDataFromDB()
        
        placeName = ""
        placeLocation = ""
        placeType = ""
        image = nil
    }
    
    //MARK: - Delete object from data base
    func deleteObject(index: IndexSet) {
        guard let index = index.first else { return }
        let item = places[index]
        StorageManager.deleteObject(item)
        
        getDataFromDB()
    }
    
    //MARK: - Edit current place
    func editPlace(object: Place) {
        let imageData = image?.pngData() ?? UIImage(named: "imagePlaceholder")?.pngData()
        try! realm.write{
            object.name = placeName
            object.location = placeLocation
            object.type = placeType
            object.rating = 0.0
            object.image = imageData!
        }
        
        placeName = ""
        placeLocation = ""
        placeType = ""
        image = nil
    }
}
