//
//  LoginScreen.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI

struct LoginScreen: View {
    @State var email:String = ""
    @State var password:String = ""
    var body: some View {
        NavigationView{
            GeometryReader { screen in
                VStack(alignment:.leading) {
                    VStack(alignment: .leading){
                        Text("Wellcome,")
                            .font(.largeTitle)
                            .bold()
                        Text("Login to continue")
                            .font(.title)
                        
                        
                    }.padding()
                  
                    VStack (spacing: 25){
                        TextField("Email", text: $email)
                            .frame(height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                             .stroke(Color.gray, lineWidth: 1)
                                             .frame(height: 1)
                                             .padding(.top, 44)
                            )
                            .padding(.horizontal, 16)
                        
                        SecureField("Password", text: $password)
                            .frame(height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                             .stroke(Color.gray, lineWidth: 1)
                                             .frame(height: 1)
                                             .padding(.top, 44)
                            )
                            .padding(.horizontal, 16)
                    }
                    .padding(.top,40)
                    .padding()
                    
                    Spacer()
                    VStack(alignment: .center){
                        NavigationLink(destination: HomeScreen()) {
                         
                            
                            Text("Login")
                                .frame(minWidth: 0, maxWidth: screen.size.width/2)
                                .padding()
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                    }
                    .frame(minWidth: 0, maxWidth: screen.size.width)
                    
                }
                .background(LinearGradient(colors: [Color("SplashScreenBgColor1"),Color("SplashScreenBgColor")], startPoint: .top, endPoint: .bottom))
            }
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginScreen()
        
        
    }
}
