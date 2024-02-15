//
//  ContentView.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI

struct LandingScreen: View {
    var body: some View {
        NavigationView {
            GeometryReader { screen in
                VStack {
                    
                    Image("landingImage")
                        .resizable()
                        .frame(height: screen.size.width)
                    
                    Spacer()
                    HStack {
                        // Signup Button
                        NavigationLink(destination: SignUpScreen()) {
                            Text("Signup")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                        
                        // Login Button
                        NavigationLink(destination: LoginScreen()) {
                            Text("Login")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                    }
                    .padding()
                }
            
                .frame(maxHeight: .infinity)
                .background(LinearGradient(colors: [Color("SplashScreenBgColor1"),Color("SplashScreenBgColor")], startPoint: .top, endPoint: .bottom))
                
                .navigationTitle("Med Book")
            }
        }
    }
}

struct LandingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LandingScreen()
    }
}
