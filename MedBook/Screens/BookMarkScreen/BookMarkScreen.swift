//
//  BookMarkScreen.swift
//  MedBook
//
//  Created by Mithun M R on 15/02/24.
//

import SwiftUI

struct BookMarkScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = BookMarkScreenViewModel()
    var body: some View {
        GeometryReader { screen in
            List {
                ForEach(vm.books , id: \.id) { book in
                    BookDetailsView(book: book)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .padding(10)
                        )
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing){
                            ZStack{
                                Button {
                                    vm.removeBook(id:book.id)
                                }label: {
                                    Image("Bookmark")
                                }
                            }.tint(.clear)
                        }
                }
            }
            .overlay{
                    ToastView(isPresented: $vm.showToast, content: {
                        Text(vm.message)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(10)
                    })
            }
        }
        .navigationTitle("Bookmarks")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.large)
        .toolbar{
            ToolbarItem(placement:.navigationBarLeading){
                Button{
                    presentationMode.wrappedValue.dismiss()
                }label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                }
            }
        }
    }
}

struct BookMarkScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            BookMarkScreen()
        }
    }
}
