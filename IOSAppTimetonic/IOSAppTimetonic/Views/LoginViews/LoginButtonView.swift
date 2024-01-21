//
//  LoginButtonView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

struct LoginButtonView: View {
    @State var areBothFieldsValid = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Log In")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .frame(width: 100, height: 45)
                    .foregroundStyle(.white)
                    .background( areBothFieldsValid ? Color.green : Color.gray)
                    .cornerRadius(12)
            })
            .padding(.vertical, 13)
        }
    }
}

#Preview {
    LoginButtonView()
}
