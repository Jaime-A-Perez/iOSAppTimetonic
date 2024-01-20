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
            Text("Welcome!")
                .font(.title2)
                .bold()
            
            Text("Timetonic")
                .font(.largeTitle)
                .fontWeight(.black)
                .padding(.bottom, 10)
            
            EmailFieldView()
            PasswordFieldView()
            
        }
    }
}

#Preview {
    LoginView()
}
