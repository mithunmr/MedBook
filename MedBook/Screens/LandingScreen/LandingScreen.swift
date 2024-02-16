//
//  ContentView.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI

struct LandingScreen: View {
    @State private var goToLoginScreen:Bool = false
    @State private var goToSignupScreen:Bool = false

    var body: some View {
            GeometryReader { screen in
                VStack {
                    Image("landingImage")
                        .resizable()
                        .frame(height: screen.size.width)
                    
                    Spacer()
                    
                    HStack {
                        // Signup Button
                        Button {
                            goToSignupScreen.toggle()
                           
                        }label: {
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
                        Button {
                            goToLoginScreen.toggle()
                        } label: {
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
                .navigationTitle("Med Book")
                .navigationBarBackButtonHidden()
                .navigationDestination(isPresented: $goToLoginScreen){ LoginScreen()}
                .navigationDestination(isPresented: $goToSignupScreen){ SignUpScreen()}
            }
         
       
    }
}

struct LandingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{ LandingScreen()}
    }
}
