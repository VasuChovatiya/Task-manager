//
//  DBManager.swift
//  Task-2
//
//  Created by Vasu Chovatiya on 01/12/23.
//

import Foundation
import RealmSwift

class DBManager {
    
    //MARK: - Properties
    private init() {}
    static let shared = DBManager()
    var realm = try! Realm()
    
    //MARK: - Function
    open func getDataFromDB<T: Object>(object: T.Type) -> Results<T> {
        let results = realm.objects(object.self)
        return results
    }
    
    // store
    func store<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    // update
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print(error)
        }
    }
    
    // delete
    func delete<T: Object>(_ object: T) -> Bool {
        do {
            try realm.write {
                realm.delete(object)
            }
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    // delete all
    func delete() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
}

//MARK: - Extensions
public extension Results {
    func toArray<T>(_ ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}


public extension List {
    func toArray<T>(_ ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
