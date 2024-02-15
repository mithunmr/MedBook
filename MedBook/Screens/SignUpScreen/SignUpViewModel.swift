//
//  SignUpViewModel.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import Foundation


class SignUpViewModel:ObservableObject {
    let networkManager  = NetworkManager()
    @Published var countries:Countries?
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var selectedCountry:String = ""
    
    @Published var isPassword8Char:Bool = false
    @Published var isPasswordHasUppercase:Bool = false
    @Published var isPasswordHasSpecialChar:Bool = false
    
    func FetchCountryList(){
        guard let url = URL(string: "https://api.first.org/data/v1/countries" ) else {return}
        networkManager.fetchRequest(type:Countries.self,url: url){ [weak self] result in
            
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.countries = data
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func validatePassword(){
        
        isPassword8Char = password.count >= 8 ? true : false
        isPasswordHasUppercase = password.filter({$0.isUppercase}).count > 0 ? true : false
        isPasswordHasSpecialChar =  containsSpecialCharacters(password)
     
    
    }
    
    func containsSpecialCharacters(_ text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]+")
        return regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil
    }
}
