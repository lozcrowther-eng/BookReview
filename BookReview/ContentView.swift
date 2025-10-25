//
//  ContentView.swift
//  BookReview
//
//  Created by Lawrence Crowther on 25/10/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = EntriesViewModel()

    var body: some View {
        NavigationStack {
            WelcomeView()
        }
        .environmentObject(vm)
    }
}

#Preview {
    ContentView()
        .environmentObject(EntriesViewModel())
}
