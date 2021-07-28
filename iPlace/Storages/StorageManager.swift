//
//  StorageManager.swift
//  iPlace
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 28.07.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static func addObject(_ object: Place) {
        try! realm.write {
            realm.add(object)
        }
    }
    static func deleteObject(_ object: Place) {
        try! realm.write {
            realm.delete(object)
        }
    }
}
