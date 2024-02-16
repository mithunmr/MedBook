//
//  HomeScreenModel.swift
//  MedBook
//
//  Created by Mithun M R on 15/02/24.
//

import Foundation
struct BookDetails:Codable {
    var id:UUID = UUID()
    var title:String
    var ratingsAverage:Double
    var ratingsCount:Int
    var authorName:[String]
    var coverImage:Int
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case authorName = "author_name"
        case coverImage = "cover_i"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? "Unknown Title"
        ratingsAverage = try container.decodeIfPresent(Double.self, forKey: .ratingsAverage) ?? 0.0
        ratingsCount = try container.decodeIfPresent(Int.self, forKey: .ratingsCount) ?? 0
        authorName = try container.decodeIfPresent([String].self, forKey: .authorName) ?? []
        coverImage = try container.decodeIfPresent(Int.self, forKey: .coverImage) ?? 0
    }
    
    
    init (id:UUID = UUID(), title:String,ratingsAverage:Double,ratingsCount:Int,authorName:[String],coverImage:Int){
        self.id = id
        self.title = title
        self.ratingsCount = ratingsCount
        self.ratingsAverage = ratingsAverage
        self.coverImage = coverImage
        self.authorName = authorName
        
    }
}
struct BookApiResponse:Codable{
    var docs:[BookDetails]
}


