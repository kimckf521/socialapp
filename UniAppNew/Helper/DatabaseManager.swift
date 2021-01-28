//
//  DatabaseManager.swift
//  UniAppNew
//
//  Created by Kim on 28/1/21.
//

import Foundation
import FirebaseDatabase
import CoreLocation

final class DatabaseManager {

    /// Shared instance of class
    public static let shared = DatabaseManager()

    private let database = Database.database().reference()

    public func test() {
        database.child("foo").setValue(["something": true])
    }

}
