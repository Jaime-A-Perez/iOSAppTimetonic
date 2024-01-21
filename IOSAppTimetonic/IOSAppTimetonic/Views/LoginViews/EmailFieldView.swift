//
//  EmailFieldView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct EmailFieldView: View {
    @StateObject var loginViewModel : LoginViewModel
    
    @State var didTouchFiel = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text($loginViewModel.user.nameEmail.wrappedValue)// Display the label for the email field
                .font(.title3)
            
            HStack {
                // Email input field
                TextField($loginViewModel.user.nameEmail.wrappedValue.lowercased(), text: $loginViewModel.user.email)
                    .accessibilityIdentifier("emailTextField")
                    .font(.headline)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.primary.opacity(0.2))
                    .frame(width: 300, height: 45)
                    .tint(Color.primary)
                    .cornerRadius(12)
                    .onTapGesture {
                        didTouchFiel = true
                    }
                
                // Conditional display of validation icon based on email field input
                if didTouchFiel && $loginViewModel.user.email.wrappedValue != "" {
                    Image(systemName: loginViewModel.isValidEmail ? "checkmark.circle" : "x.circle" )
                        .accessibilityIdentifier("emailValidationIcon")
                        .font(.title3)
                        .foregroundStyle(loginViewModel.isValidEmail ? .green : .red.opacity(0.7))
                } else {
                    HStack {}
                }
            }
        }
        .padding(.vertical, 10)
    }
}


