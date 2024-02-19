//
//  SignUpViewModel.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import Foundation


class SignUpViewModel:ObservableObject {
    let networkManager  = NetworkManager()
    @Published var countries:Countries = Countries(data: [:])
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var selectedCountry:String = ""
    
    @Published var isEmailValid:Bool = false
    @Published var isPassword8Char:Bool = false
    @Published var isPasswordHasUppercase:Bool = false
    @Published var isPasswordHasSpecialChar:Bool = false

    @Published var goToHomeScreen:Bool = false
    
    @Published var presentSheet:Bool = false
    @Published var message:String = ""
    
    
    init() {
        if let thecountries =  CheckForStoredCountryData(){
            print("Fetching from CoreData")
            countries = thecountries
        } else {
            print("Fetching from Api")
            fetchCountryList()
        }
        if let location = SessionManager.shared.getLocationData(){
            selectedCountry = location.countryCode
            
        }else{
            fetchLocation()
        }
    }
    
    func fetchCountryList(){
        guard let url = URL(string: "https://api.first.org/data/v1/countries" ) else {return}
        networkManager.fetchRequest(type:Countries.self,url: url){ [weak self] result in
            guard let weakSelf = self else {return}
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    weakSelf.countries = data
                    weakSelf.saveCountryData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func SignUp(){
        if validateUserDetails(){
            let user = UserEntity(context:CoreDataManager.shared.viewContext)
            user.id = UUID()
            user.email = email
            user.password = password
            user.country = selectedCountry
            
            if CoreDataManager.shared.saveContext(){
                SessionManager.shared.saveUserSession(email: email)
                goToHomeScreen.toggle()
            }else{
                message = "Something went wrong try signing again."
                presentSheet.toggle()
            }
        }else{
            message = "Inavalid user details"
            presentSheet.toggle()
        }
    }
    
    func validateUserDetails()->Bool{
        return isEmailValid && isPassword8Char && isPasswordHasUppercase && isPasswordHasSpecialChar && !selectedCountry.isEmpty
    }
    
    func checkEmailCondition(){
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
    
    func checkPasswordConditions(){
        isPassword8Char = password.count >= 8 ? true : false
        isPasswordHasUppercase = password.filter({$0.isUppercase}).count > 0 ? true : false
        isPasswordHasSpecialChar =  containsSpecialCharacters(password)
    }
    
    func containsSpecialCharacters(_ text: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "[^a-zA-Z0-9]+")
        return regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil
    }
    
    
    func saveCountryData(){
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let weakSelf = self else {return}
            let context = CoreDataManager.shared.viewContext
            for (countryCode, countryDetails) in weakSelf.countries.data  {
                let countryEntity = CountryEntity(context: context)
                countryEntity.countryCode = countryCode
                countryEntity.country = countryDetails.country
                countryEntity.region = countryDetails.region
            }

            do {
                try context.save()
                print("-----Countries Saved to DB------")
            } catch {
                print("Error saving countries: \(error.localizedDescription)")
            }
        }
    }
    
    func CheckForStoredCountryData()-> Countries?{
        let fetchRequest = CountryEntity.fetchRequest()
        do {
            let theCountries = try CoreDataManager.shared.viewContext.fetch(fetchRequest)
            if theCountries.isEmpty { return nil }
            var countries =  Countries(data: [:])
            theCountries.forEach({
                countries.data[$0.countryCode ?? ""] = CountryDetails(country: $0.country ?? "", region: $0.region ?? "" )
            })
            return countries
        } catch {
            return nil
        }
    }
    
    func fetchLocation(){
        print("Fetch Location.....")
        guard let url = URL(string: "http://ip-api.com/json/" ) else {return}
        networkManager.fetchRequest(type:LocationData.self,url: url){ [weak self] result in
            guard let weakSelf = self else {return}
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    weakSelf.selectedCountry = data.countryCode
                    SessionManager.shared.storeLocationData(data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
