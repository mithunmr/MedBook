//
//  LoginScreenViewModel.swift
//  MedBook
//
//  Created by Mithun M R on 15/02/24.
//

import Foundation


class LoginScreenViewModel:ObservableObject{
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var goToHomeScreen:Bool = false
    
    @Published var presentSheet:Bool = false
    @Published var message:String = ""
    
    func authenticateUser(){
        do {
            let users = try CoreDataManager.shared.viewContext.fetch(UserEntity.fetchRequest())
            if !users.filter({$0.email == email && $0.password == password}).isEmpty {
                SessionManager.shared.saveUserSession(email: email)
                email = ""
                password = ""
                goToHomeScreen.toggle()
            } else {
                message = "Invalid Credential"
                presentSheet.toggle()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
