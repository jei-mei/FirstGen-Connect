//
//  FirebaseManager.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/7/24.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}
