//
//  LoginButtonView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct LoginButtonView: View {
    @StateObject var loginViewModel : LoginViewModel
    @State var changeView = false
    
    var body: some View {
        HStack {
            Spacer()
            // Login button
            Button(action: {
                changeView = true
            }, label: {
                Text("Log In")
                    .fontWeight(.heavy)
                    .accessibilityIdentifier("loginButton")
                    .font(.title2)
                    .frame(width: 100, height: 45)
                    .foregroundStyle(.white)
                    .background( loginViewModel.isValidEmail && loginViewModel.isValidPassword ? Color.green : Color.gray)
                    .cornerRadius(12)
            })
            .padding(.vertical, 13)
            .disabled(!(loginViewModel.isValidEmail && loginViewModel.isValidPassword))
            .background(
                NavigationLink("", destination: AuthVerificationView(), isActive: $changeView)
            )
        }
    }
}


