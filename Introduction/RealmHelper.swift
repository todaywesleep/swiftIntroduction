//
//  RealmHelper.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/17/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper: NSObject {
    static let sharedInstance = RealmHelper()
    
    lazy var realm: Realm? = nil
    
    private override init(){
        super.init()
        do {
            self.realm = try Realm()
        } catch {
            self.prepareMigration()
            self.realm = try! Realm()
        }
    }
    
    func createItemWrite(item: ItemModel) {
        try! realm!.write {
            realm!.add(item)
        }
    }
    
    func deleteItemWrite(item: ItemModel) {
        try! realm!.write {
            realm!.delete(item)
        }
    }
    
    func getAllWrites() -> [ItemModel] {
        return realm!.objects(ItemModel.self).reversed()
    }
    
    private func prepareMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                print("Old schema version: \(oldSchemaVersion)")
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
