//
//  LoginScreen.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI

struct LoginScreen: View {
    @ObservedObject var vm = LoginScreenViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
 
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
                        TextField("Email", text: $vm.email)
                            .frame(height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                             .stroke(Color.gray, lineWidth: 1)
                                             .frame(height: 1)
                                             .padding(.top, 44)
                            )
                            .padding(.horizontal, 16)
                        
                        SecureField("Password", text: $vm.password)
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
                        
                        Button {
                            vm.authenticateUser()
                        }label: {
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
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
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
            .alert(isPresented: $vm.presentSheet){
                Alert(
                    title: Text("Opps!!!"),
                    message: Text(vm.message),
                    primaryButton: .default(Text("OK")),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
            .navigationDestination(isPresented: $vm.goToHomeScreen){
                HomeScreen()
            }
        
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
    
        LoginScreen()
    }
}
