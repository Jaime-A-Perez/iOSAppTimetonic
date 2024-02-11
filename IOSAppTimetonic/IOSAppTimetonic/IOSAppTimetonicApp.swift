//
//  IOSAppTimetonicApp.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 20/01/24.
//

import SwiftUI

@main
struct IOSAppTimetonicApp: App {
    @StateObject private var authVerificationViewModel = AuthVerificationViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVerificationViewModel)
        }
    }
}
