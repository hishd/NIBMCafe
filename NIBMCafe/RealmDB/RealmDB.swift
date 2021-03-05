//
//  RealmDB.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-05.
//

import Foundation
import RealmSwift

class RealmDB {
    static let instance = RealmDB()
    let realm = try! Realm()
    
    var delegate: RealmActions?
    
    //Make Singleton
    fileprivate init() {}

    
}

protocol RealmActions {
    
}
