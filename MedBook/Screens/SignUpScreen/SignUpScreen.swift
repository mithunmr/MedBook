//
//  SignUpScreen.swift
//  MedBook
//
//  Created by Mithun M R on 14/02/24.
//

import SwiftUI

struct SignUpScreen: View {
    
    @ObservedObject var vm = SignUpViewModel()
    var body: some View {
        NavigationView{
            GeometryReader { screen in
                VStack(alignment:.leading) {
                    VStack(alignment: .leading){
                        Text("Wellcome,")
                            .font(.largeTitle)
                            .bold()
                        Text("Sign-up to continue")
                            .font(.title)
                    }.padding()
                  
                    //TextField
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
                            .onChange(of: vm.email, perform: {_ in
                                print(vm.email)
                                
                            })
                        
                        TextField("Password", text: $vm.password)
                            .frame(height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                             .stroke(Color.gray, lineWidth: 1)
                                             .frame(height: 1)
                                             .padding(.top, 44)
                            )
                            .padding(.horizontal, 16)
                            
                            .onChange(of: vm.password, perform: {_ in
                                vm.validatePassword()
                                
                            })
                            
                            
                    }
                    .padding(.top,40)
                    .padding()
                    
                    
                    VStack(alignment: .leading,spacing: 20){
                        HStack {
                            Image(systemName: vm.isPassword8Char ? "checkmark.square" : "square"  )
                            Text("At least 8 characters")
                                .bold()
                        }
                        HStack {
                            Image(systemName: vm.isPasswordHasUppercase ? "checkmark.square" : "square")
                            Text("Must contain an uppercase letter")
                                .bold()
                        }
                        HStack {
                            Image(systemName: vm.isPasswordHasSpecialChar ? "checkmark.square" : "square")
                            Text("Contains a spacial character")
                                .bold()
                        }
                    }
                    .padding(.horizontal,32)
                    .padding(.top)
                    
                    Picker("", selection: $vm.selectedCountry){
                        ForEach(vm.countries?.data.keys.sorted() ?? [], id: \.self){ countryKey in
                            Text(vm.countries?.data[countryKey]?.country ?? "")
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 140)
                    .padding(.horizontal,32)
                    .padding(.top)
                    
                    Spacer()
                    // Let's go button
                    VStack(alignment: .center){
                        NavigationLink(destination: LoginScreen()) {
                            Text("Lets Go")
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
                .frame(maxHeight: .infinity,alignment: .top)
                .background(LinearGradient(colors: [Color("SplashScreenBgColor1"),Color("SplashScreenBgColor")], startPoint: .top, endPoint: .bottom))
            }
            .onAppear{
                vm.FetchCountryList()
            }
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
