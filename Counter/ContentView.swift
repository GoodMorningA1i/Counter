//
//  ContentView.swift
//  Counter
//
//  Created by Ali Syed on 2025-12-01.
//

import SwiftUI

struct ContentView: View {
    @State private var count: Int {
        didSet {
            if let encoded = try? JSONEncoder().encode(count) {
                UserDefaults.standard.set(encoded, forKey: "Count")
            }
        }
    }
    
    init() {
        if let savedItem = UserDefaults.standard.data(forKey: "Count") {
            if let decodedItem = try? JSONDecoder().decode(Int.self, from: savedItem) {
                count = decodedItem
                return
            }
        }
        
        count = 0
    }
    
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
