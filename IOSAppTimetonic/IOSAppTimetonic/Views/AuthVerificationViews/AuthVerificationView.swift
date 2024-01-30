//
//  AuthVerificationView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 29/01/24.
//

import SwiftUI

struct AuthVerificationView: View {
    @State var isThereAnAnswer = false
    @State var isAuthVerify = true
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("Authentication")
                .font(.largeTitle)
                .padding()
            Spacer()
            if isThereAnAnswer {
                Image(systemName: isAuthVerify ? "checkmark.circle" : "x.circle")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .foregroundColor(isAuthVerify ? .green : .red.opacity(0.9))
            } else {
                ProgressView()
                    .scaleEffect(x:4, y:4, anchor: .center)
                    .padding()
            }
            Spacer()
            Text(isAuthVerify ? "Verify" : "Error: ")
                .font(.title)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    AuthVerificationView()
}
