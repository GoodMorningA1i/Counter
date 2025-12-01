//
//  ContentView.swift
//  Counter
//
//  Created by Ali Syed on 2025-12-01.
//

import SwiftUI

struct ContentView: View {
    @State private var count = 0
    
    var body: some View {
        Button(action: {
            count += 1
        }, label: {
            Text("\(count)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundStyle(.black)
                .font(.system(size: 100))
        })
    }
}

#Preview {
    ContentView()
}
