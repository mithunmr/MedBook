//
//  HomeScreenViewModel.swift
//  MedBook
//
//  Created by Mithun M R on 15/02/24.
//

import Foundation
enum sortOptions:String,CaseIterable{
    case title = "Title"
    case average = "Average"
    case hits = "Hits"
}
class HomeScreenViewModel:ObservableObject{
    let networkManager = NetworkManager()
    @Published var books:[BookDetails] = []
    @Published var searchText:String = ""
    @Published var goToBookMark:Bool =  false
    @Published var goToLanding:Bool = false
    
    @Published var showToast:Bool = false
    @Published var message:String = ""
    @Published var isLoading = false
    @Published var sortBy:sortOptions = .title
    
    private var currentPage = 1
    private let limit = 10
    
    func search(){
        if searchText.count >= 3{
            currentPage = 1
            books.removeAll()
            fetchData()
        }
    }
    
    func fetchData(){
        isLoading = true
        DispatchQueue.global(qos: .userInteractive).async{ [weak self] in
            guard  let weakSelf = self else{ return }
            let offset = (weakSelf.currentPage - 1) * weakSelf.limit
       
            guard let url = URL(string: "https://openlibrary.org/search.json?title=\(weakSelf.searchText.lowercased())&limit=\(weakSelf.limit)&offset=\(offset)")
            else {
                print("BAD Url")
                return
            }
            weakSelf.networkManager.fetchRequest(type:BookApiResponse.self,url: url){  result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        weakSelf.books.append(contentsOf:data.docs)
                        weakSelf.isLoading = false
                        
                        weakSelf.books.forEach({
                            print("---",$0.coverImage)
                        })
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func fetchMoreDataIfNeeded(currentItemIndex: Int) {
         if currentItemIndex == books.count - 1 {
             currentPage += 1
             fetchData()
         }
    }
    
    func addToBookMark(_ thebook:BookDetails){
        let book = BookEntity(context:CoreDataManager.shared.viewContext)
        book.id = thebook.id
        book.title = thebook.title
        book.authorName = thebook.authorName.joined(separator: ",")
        book.coverImage = Int32(thebook.coverImage )
        book.ratingsCount = Int16(thebook.ratingsCount )
        book.ratingsAverage = thebook.ratingsAverage
        book.email = SessionManager.shared.getUserSession()
        if CoreDataManager.shared.saveContext(){
            message = "Bookmark successfull"
            showToast.toggle()
        }else{
            message = "Bookmark Failed"
            showToast.toggle()
        }
    }
    
    
    func addFilter(type:sortOptions){
        DispatchQueue.main.async{ [weak self] in
            guard  let weakSelf = self else{ return }
            weakSelf.books.sort(by: {
                switch type {
                case .title:
                   return $0.title < $1.title
                case .average:
                   return $0.ratingsAverage > $1.ratingsAverage
                case .hits:
                   return $0.ratingsCount > $1.ratingsCount
                }
            })
        }
    }
    
    
    func logout(){
        SessionManager.shared.clearUserSession()
        goToLanding.toggle()
    }
}
