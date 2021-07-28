//
//  Place.swift
//  iPlace
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 28.07.2021.
//

import RealmSwift
import Foundation
import SwiftUI

class Place: Object, Identifiable {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var location: String? = ""
    @objc dynamic var type: String? = ""
    @objc dynamic var image: Data = Data()
    @objc dynamic var rating: Double = 0.0
}
