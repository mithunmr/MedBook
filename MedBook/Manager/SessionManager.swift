//
//  SessionManager.swift
//  MedBook
//
//  Created by Mithun M R on 16/02/24.
//

import Foundation
class SessionManager {
    static let shared = SessionManager()
    private let userDefaults = UserDefaults.standard
    private let userSessionKey = "UserSession"
    private init(){}
    
    func saveUserSession(email: String) {
        userDefaults.set(email, forKey: userSessionKey)
    }
    
    func getUserSession() -> String? {
        return userDefaults.string(forKey: userSessionKey)
    }
    
    func clearUserSession() {
        userDefaults.removeObject(forKey: userSessionKey)
    }
   
    func storeLocationData(_ locationData: LocationData) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(locationData) {
            userDefaults.set(encodedData, forKey: "locationData")
        }
    }
    
    func getLocationData() -> LocationData? {
        if let savedData = userDefaults.data(forKey: "locationData") {
            let decoder = JSONDecoder()
            if let locationData = try? decoder.decode(LocationData.self, from: savedData) {
                return locationData
            }
        }
        return nil
    }
}
