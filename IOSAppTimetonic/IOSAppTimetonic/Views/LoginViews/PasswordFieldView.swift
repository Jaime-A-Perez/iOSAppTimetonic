//
//  PasswordFieldView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct PasswordFieldView: View {
    @State var passwordUser = ""
    @State var isValidPassword = true
    @State var didTouchFiel = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Password")
                .font(.title3)
            HStack {
                SecureField("*********", text: $passwordUser)
                    .font(.headline)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color.primary.opacity(0.2))
                    .frame(width: 300)
                    .tint(Color.primary)
                    .cornerRadius(12)
                    .onTapGesture {
                        didTouchFiel = true
                    }
                
                if didTouchFiel && passwordUser != "" {
                    Image(systemName: isValidPassword ? "checkmark.circle" : "x.circle" )
                        .font(.title3)
                        .foregroundStyle(isValidPassword ? .green : .red.opacity(0.7))
                } else {
                    HStack {}
                }
            }
        }.padding(.vertical, 10)
    }
}
#Preview {
    PasswordFieldView()
}
