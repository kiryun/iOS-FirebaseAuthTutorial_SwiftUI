//
//  ContentView.swift
//  FirebaseTutorial
//
//  Created by Gihyun Kim on 2020/03/23.
//  Copyright © 2020 wimes. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class viewModel{
    
}
struct ContentView: View {
    @State private var email: String = ""
    @State private var pw: String = ""
    
    var body: some View {
        VStack {
            Text("E-mail")
                .bold()
            TextField("Enter your email", text: $email)
            
            Text("Password")
                .bold()
            SecureField("password", text: $pw)
            
            Button(action: self.login) {
                Text("Login")
            }
            
            Button(action: self.signUp) {
                Text("SignUp")
            }
            
            Button(action: self.fbLogin){
                Text("FB Login")
            }
            
        }
    }
    
    func login(){
        // 'FBSDKLoginButton' has been renamed to 'FBLoginButton'
        
        Auth.auth().signIn(withEmail: self.email, password: self.pw) { (user, error) in
            if user != nil{
                print("login success")
                print(user)
            }else{
                print("login failed")
                print(error)
            }
        }
    }
    
    func signUp(){
        Auth.auth().createUser(withEmail: self.email, password: self.pw) { (user, error) in
            if(user != nil){
                print("register successs")
                print(user)
            }else{
                print("register failed")
                print(error)
            }
        }
    }
    
    func fbLogin(){
        let cont = UIHostingController(rootView: self) // convert to UIController from SwiftUI
        // 'FBSDKLoginManager' has been renamed to 'LoginManager'
        let fbLoginManager: LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: cont) { (result, err) in
            if err != nil{
                print("Process error")
            }else if result?.isCancelled == true{
                print("Cancelled")
            }else{
                print("Logged in")
                self.getFBUserData()
            }
        }
        
    }
    
    func getFBUserData(){
        if AccessToken.current != nil{
            GraphRequest(graphPath: "me", parameters: ["fieldds": "id, name, first_name, last_name, picture.type(large), email"]).start { (connection, result, err) in
                if(err == nil){
                    print(result)
                }else{
                    self.fbFirebaseAuth()
                }
            }
        }
    }
    
    func fbFirebaseAuth(){
        // 'FIRFacebookAuthProvider' has been renamed to 'FacebookAuthProvider'
        // 'FBSDKAccessToken' has been renamed to 'AccessToken'
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if(user != nil){
                print("FB login success")
                print(user)
//                try! Auth.auth().signOut()
            }else{
                print("FB login failed")
                print(error)
            }
        }
    }
}

//struct FBButton: UIViewControllerRepresentable{
//    typealias UIViewControllerType = FBLoginButton
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
