//
//  BookDetailsView.swift
//  MedBook
//
//  Created by Mithun M R on 15/02/24.
//

import SwiftUI

struct BookDetailsView: View {
    var book:BookDetails?
    
    var body: some View {
        HStack(alignment: .center){
            
            if let coverImage = book?.coverImage,let url = URL(string:"https://covers.openlibrary.org/b/id/\(coverImage)-M.jpg"){
                AsyncImage(url: url)
                    .frame(width: 70, height:70)
                    .cornerRadius(10)
            }else{
                Image(systemName: "globe")
            }
            VStack(alignment: .leading){
                Text(String(book?.title ?? ""))
                    .padding(.bottom,3)
            
                HStack{
                    Text(String(book?.authorName.first ?? ""))
                        .lineLimit(1)
                        .font(.system(size:14,weight: .light))
                        .foregroundColor(.gray)
                       
                    HStack{
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)

                    Text("\(book?.ratingsAverage ?? 0,specifier:"%.2f")")
                            .font(.system(size:15,weight: .light))
                    }
                    HStack{
                        Image(systemName: "chart.bar.doc.horizontal")
                            .foregroundColor(.yellow)
                        Text("\(book?.ratingsCount ?? 0)")
                            .font(.system(size:15,weight: .light))
                    }
                }
            }
        }.frame(minHeight: 80 ,alignment: .leading)
    }
}

struct BookDetailsView_Previews: PreviewProvider {
    static var previews: some View {

        BookDetailsView(book: BookDetails(
            title: "Sample Book",
            ratingsAverage: 4.5,
            ratingsCount: 100,
            authorName: ["John Doe", "Jane Doe"],
            coverImage: 12996033
        ))
    }
}
