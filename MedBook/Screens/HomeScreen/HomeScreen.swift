//
//  HomeScreen.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI

struct HomeScreen: View {
    @State var  searchText:String = ""
    var body: some View {
        NavigationView{
            GeometryReader { screen in
                VStack (alignment: .leading){
                    Text("Which topic intrests \nyou today?")
                        .multilineTextAlignment(.leading)
                        .font(.system(.title,weight: .semibold))
                        .padding()
                    
                    SearchBar(searchText: $searchText)
                        .padding()
                        
             
                }
                .navigationBarItems(trailing: CustomButtonView())
                .navigationBarItems(leading:  LogoAndTitleView())
                
               
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
    var body: some View {
        HStack{
            Button(action: {
                // Perform custom action
            }) {
                Image(systemName: "bookmark.fill")
                    .imageScale(.large)
                    .tint(.black)
            }
            Button(action: {
                // Perform custom action
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
    var body: some View {
        HStack {
            Button{
                print("---")
            }label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
            }.padding(.leading)
                .padding(.vertical)
            TextField("Search", text: $searchText)
                .foregroundColor(.black)
            Button{
                print("---")
            }label: {
                Image(systemName: "clear")
                    .foregroundColor(.gray)
            }.padding(.leading)
                .padding(.vertical)
                .padding(.trailing)
                
        }.background(.gray.opacity(0.2))
            .buttonBorderShape(.capsule)
            .cornerRadius(10)
        
        
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
