//
//  HomeScreen.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI


struct HomeScreen: View {
    @ObservedObject var vm = HomeScreenViewModel()
    
    var body: some View {
        GeometryReader { screen in
            VStack (alignment: .leading){
                Text("Which topic interests \nyou today?")
                    .multilineTextAlignment(.leading)
                    .font(.system(.title,weight: .semibold))
                    .padding()
                
                SearchBar(searchText: $vm.searchText,searchAction: {vm.search()})
                    .padding()
                Spacer()
                if !vm.books.isEmpty {
                    VStack {
                        HStack{
                            Text("Sort By:")
                            Picker("", selection: $vm.sortBy){
                                ForEach(sortOptions.allCases,id: \.self){ option in
                                    Text(option.rawValue)
                                }
                            }.pickerStyle(.segmented)
                                .onChange(of: vm.sortBy){ newValue in
                                    vm.addFilter(type: newValue)
                                }
                        }.padding(.horizontal)
                        
                        List {
                            ForEach(vm.books, id: \.id) { book in
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
                                                vm.addToBookMark(book)
                                            }label: {
                                                Image("Bookmark")
                                            }
                                        }.tint(.clear)
                                    }
                                    .onAppear {
                                        vm.fetchMoreDataIfNeeded(currentItemIndex: vm.books.firstIndex(where: { $0.id == book.id }) ?? 0)
                                    }
                            }
                        }
                    }
                    
                }
                else{
                    if vm.isLoading {
                        
                        VStack{
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.green)
                        }.frame(minWidth: screen.size.width)
                        Spacer()
                    }
                }
                
            }
            
            .background(Color("HomeScreenBG"))
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: CustomButtonView(goToBookMark: $vm.goToBookMark,logOutAction: {vm.logout()}))
            .navigationBarItems(leading: LogoAndTitleView())
            .navigationDestination(isPresented: $vm.goToBookMark){BookMarkScreen()}
            .navigationDestination(isPresented: $vm.goToLanding){LandingScreen()}
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
    }
}

struct LogoAndTitleView: View {
    var body: some View {
        HStack {
            Image(systemName: "book.fill")
                .resizable()
                .frame(width: 30, height: 30)
            Text("MedBook")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading,3)
        }
    }
}

struct CustomButtonView: View {
    @Environment(\.presentationMode) var presentation
    @Binding var goToBookMark:Bool
    var logOutAction:(()->Void)
    var body: some View {
        HStack{
            Button(action: {
                goToBookMark.toggle()
            }) {
                Image(systemName: "bookmark.fill")
                    .imageScale(.large)
                    .tint(.black)
            }
            Button(action: {
                logOutAction()
            }) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .imageScale(.large)
                    .tint(.pink)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var searchText:String
    var searchAction:(()->Void)
    var body: some View {
        HStack {
            Button{
                searchAction()
            }label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
            }.padding(.leading)
                .padding(.vertical)
            TextField("Search", text: $searchText)
                .foregroundColor(.black)
                .autocorrectionDisabled()
                .onChange(of: searchText){ _ in
                    searchAction()
                }
                .onSubmit {
                    searchAction()
                }
            
            Button{
                searchText = ""
            }label: {
                Image(systemName: "clear")
                    .foregroundColor(.gray)
            }.padding(.leading)
                .padding(.vertical)
                .padding(.trailing)
            
        }
        .background(.gray.opacity(0.2))
        .buttonBorderShape(.capsule)
        .cornerRadius(10)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            HomeScreen()
        }
        
    }
}
