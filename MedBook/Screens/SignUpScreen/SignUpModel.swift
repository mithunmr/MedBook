//
//  SignUpModel.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import Foundation
struct CountryDetails: Codable {
    let country: String
    let region: String
}


struct Countries:Codable { 
    var data:[String:CountryDetails]
}
