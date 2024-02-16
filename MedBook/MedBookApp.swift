//
//  MedBookApp.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI

@main
struct MedBookApp: App {
   
    private func isUserLoggedIn() -> Bool{
          if let _ = SessionManager.shared.getUserSession() {
             return true
          }else{
              return false
          }
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack{
               
                if isUserLoggedIn() {
                    HomeScreen()
                }else{
                    LandingScreen()
                }
            }
          
        }
    }
}
