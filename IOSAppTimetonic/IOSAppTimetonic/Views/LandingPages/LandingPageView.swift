//
//  LandingPageView.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 7/02/24.
//

import SwiftUI

struct LandingPageView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            Text("All Books")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            listView
                .padding(.horizontal, 5)
                .shadow(radius: 3)
        }
    }
    
    private var listView: some View {
        List {
            bookRow()
                .padding(.vertical, 5)
        }
    }
    
    @ViewBuilder
    private func bookRow() -> some View {
        HStack {
            bookImage()
            bookDetails()
        }
    }
    
    @ViewBuilder
    private func bookImage() -> some View {
        Image(systemName: "book.fill")
            .frame(width: 100, height: 100)
            .cornerRadius(5)
            .shadow(radius: 6, x: -2, y: 2)
    }
    
    @ViewBuilder
    private func bookDetails() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Title")
                .font(.headline)
                .foregroundColor(.primary)
            Text("Subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
        .padding(.leading, 6)
    }
}

#Preview {
    LandingPageView()
}
