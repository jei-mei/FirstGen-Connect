//
//  CreateAccountView.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/7/24.
//

import SwiftUI
import Firebase

struct CreateAccountView: View {
    
    @State var email = ""
    @State var password = ""
    @State var confirmPass = ""
    @State var loginStatusMessage = ""
    
    @State var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background2")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Text("Create Account")
                        .font(.largeTitle)
                    .fontWeight(.bold)
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .cornerRadius(64)
                            }
                            else {
                                Image(systemName: "photo.badge.plus")
                                    .foregroundColor(.gray)
                                    .frame(width: 120, height: 120)
                                    .font(.system(size: 80))
                                    .padding(8)
                            }
                        }
                        .overlay(RoundedRectangle(cornerRadius: 70)
                            .stroke(Color.gray, lineWidth: 3))
                    }
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Group {
                        TextField("School Email*", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password*", text: $password)
                        SecureField("Confirm Password*", text: $confirmPass)
                    }
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color("Cloud"))
                    .cornerRadius(10)
                    .padding(.vertical, 5)
                    
                    
                    if password != confirmPass {
                        Text("Password does not match")
                            .foregroundColor(.red)
                        Button {
                            
                        } label: {
                            Text("Continue")
                                .padding()
                                .frame(width: 120)
                                .foregroundColor(.black)
                                .background(Color("Canvas"))
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                    }
                    else {
                        Button {
                            createAccount()
                        } label: {
                            Text("Continue")
                                .padding()
                                .frame(width: 120)
                                .foregroundColor(.black)
                                .background(Color("Canvas"))
                                .cornerRadius(10)
                                .padding(.vertical)
                        }
                        
                        Text(self.loginStatusMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal, 50)
                    }
                    
                    Spacer()
                        .frame(height: 80)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    
    @State var image: UIImage?
    
    private func createAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err.localizedDescription)"
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            //self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                //self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString as Any)
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileURL: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileURL: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let userData = ["email": self.email, "uid": uid, "profileImageURL": imageProfileURL.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
            }
    }
}

#Preview {
    CreateAccountView()
}
