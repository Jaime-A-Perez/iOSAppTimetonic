//
//  EmailFieldView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct EmailFieldView: View {
    @State var emailUser = ""
    @State var isValidEmail = false
    @State var didTouchFiel = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Email")
                .font(.title3)
            HStack {
                TextField("email", text: $emailUser)
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
                
                if didTouchFiel && emailUser != "" {
                    Image(systemName: isValidEmail ? "checkmark.circle" : "x.circle" )
                        .font(.title3)
                        .foregroundStyle(isValidEmail ? .green : .red.opacity(0.7))
                } else {
                    HStack {}
                }
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    EmailFieldView()
}
