//
//  LoginView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct LoginView: View {
    var loginViewModel = LoginViewModel.shared
    
    private let frameWidth: CGFloat = 300

    var body: some View {
        
        VStack{
            
            Spacer()
            Spacer()
            
            Text("Welcome!")
                .font(.title2)
                .bold()
            
            Text("Timetonic")
                .font(.largeTitle)
                .fontWeight(.black)
                
            Spacer()
            
            EmailFieldView(loginViewModel: loginViewModel)
            
            PasswordFieldView(loginViewModel: loginViewModel)
            
            LoginButtonView(loginViewModel: loginViewModel)
            
            Spacer()
            Spacer()
            
        }.frame(width: frameWidth)
    }
}

#Preview {
    LoginView()
}
