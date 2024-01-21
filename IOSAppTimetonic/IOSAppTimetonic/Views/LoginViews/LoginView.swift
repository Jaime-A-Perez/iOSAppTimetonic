//
//  LoginView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct LoginView: View {

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
            
            EmailFieldView()
            
            PasswordFieldView()
            
            LoginButtonView()
            
            Spacer()
            Spacer()
            
        }.frame(width: 300)
    }
}

#Preview {
    LoginView()
}
