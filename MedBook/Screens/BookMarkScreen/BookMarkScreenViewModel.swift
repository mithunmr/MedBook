import Foundation
class BookMarkScreenViewModel: ObservableObject {
    
    @Published var books: [BookDetails] = []
    
    @Published var presentSheet:Bool = false
    @Published var messageTitle:String = ""
    @Published var message:String = ""
    
    init() {
        getBookMarkedBooks()
    }
    
    func getBookMarkedBooks() {
        do {
            let request = BookEntity.fetchRequest()
            request.predicate = NSPredicate(format: "email == %@",SessionManager.shared.getUserSession() ?? "")
            let theBooks = try CoreDataManager.shared.viewContext.fetch(request)
            
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
              
                weakSelf.books = theBooks.map({
                 
                    return BookDetails(id:$0.id ?? UUID(), title: $0.title ?? "", ratingsAverage: $0.ratingsAverage, ratingsCount: Int($0.ratingsCount), authorName: $0.authorName?.components(separatedBy: ",") ?? [], coverImage: Int($0.coverImage))
                })
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeBook(id:UUID){
        let request = BookEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@",id as CVarArg)
        
        do {
            let context = CoreDataManager.shared.viewContext
            let result = try context.fetch(request)
            guard let bookEntity = result.first else {
                print("Book not found in Core Data")
                return
            }
            context.delete(bookEntity)
            try context.save()
            messageTitle = "Great!!!"
            message = "selected book successfully removed bookmarked"
            presentSheet.toggle()
            getBookMarkedBooks()
        } catch {
            messageTitle = "opps!!!"
            message = "Something went wrong try signing again."
            presentSheet.toggle()
        }
    }
}
