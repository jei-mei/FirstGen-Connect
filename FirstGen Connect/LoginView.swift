//
//  ContentView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/2/24.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var loginStatusMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("welcomePage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Text("Welcome to")
                        .font(.largeTitle)
                    Text("FirstGen Connect!")
                        .font(.largeTitle)
                        .padding(.bottom)
                    
                    Group {
                        TextField("School Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                    }
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color("Cloud"))
                    .cornerRadius(10)
                    .padding(.bottom, 8)
                    
                    Button {
                        loginUser()
                    } label: {
                        Text("Log in")
                            .padding()
                            .frame(width: 100)
                            .foregroundColor(.black)
                            .background(Color("Canvas"))
                            .cornerRadius(10)
                            .padding(.bottom)
                    }
                    
//                    NavigationLink(destination: HomePage()) {
//                        Text("Log in")
//                            .padding()
//                            .frame(width: 100)
//                            .foregroundColor(.black)
//                            .background(Color("Canvas"))
//                            .cornerRadius(10)
//                            .padding(.bottom)
//                    }
                    
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Don't have an account? Sign up ")
                            .font(.system(size: 14))
                            + Text("here.").underline()
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.black)
                    .padding(.bottom)
                    
                    Text(self.loginStatusMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 50)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to log in user:", err)
                self.loginStatusMessage = "Failed to log in user: \(err.localizedDescription)"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            //self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
}


#Preview {
    LoginView()
}
