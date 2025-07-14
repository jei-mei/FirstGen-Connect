//
//  FriendsTab.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/3/24.
//

import SwiftUI

class MainMessagesViewModel: ObservableObject {
    
    init() {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
//            if let error = error {
//                print("Failed to fetch current user")
//            }
        }
    }
}

struct MessagesTab: View {
    var body: some View {
        NavigationView {
            //ZStack {
                //Image("background1")
                    //.resizable()
                    //.scaledToFill()
                    //.ignoresSafeArea()
                
                VStack {
                    Text("Messages")
                        .ignoresSafeArea()
                        .font(.title)
                        .bold()
                        .padding(.trailing, 210)
                        //.padding(.top, 20) // change back to 50 if it looks weird
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40) // remove if it looks weird on LoginView
                        .background(Color("Canvas"))
                    
                    ScrollView {
                        ForEach(0..<10, id: \.self) { num in
                            VStack {
                                HStack(spacing: 16) {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 32))
                                        .padding(8)
                                        .overlay(RoundedRectangle(cornerRadius: 44)
                                            .stroke(Color.black, lineWidth: 1))
                                    VStack (alignment: .leading) {
                                        Text("Username")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Message sent to user")
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(.lightGray))
                                    }
                                    Spacer()
                                    Text("1d")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                Divider()
                                    .padding(.vertical, 8)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .overlay(
                    Button {
                        print("messages")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 55))
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                            .foregroundColor(Color("Canvas"))
                            .padding(.bottom)
                    }
                    .offset(x: 145, y: 290)
                )
                .navigationBarHidden(true)
            //}
        }
    }
}

#Preview {
    MessagesTab()
}
