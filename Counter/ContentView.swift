//
//  ContentView.swift
//  Counter
//
//  Created by Ali Syed on 2025-12-01.
//

import SwiftUI

struct ContentView: View {
    @State private var showingResetConfirmation = false
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
        NavigationStack {
            Button(action: {
                increment()
            }, label: {
                Text("\(count)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.primary)
                    .font(.system(size: 100))
            })
            .sensoryFeedback(.increase, trigger: count)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        increment()
                    } label: {
                        Image(systemName: "plus")
                    }
                    Button {
                        decrement()
                    } label: {
                        Image(systemName: "minus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        showingResetConfirmation.toggle()
                    }
                    .confirmationDialog("Counter Reset", isPresented: $showingResetConfirmation) {
                        Button("Yes") { reset() }
                        Button("No") { }
                    } message: {
                        Text("Are you sure you want to reset your counter?")
                    }
                }
            }
        }
    }
    
    func increment() {
        count += 1
    }
    
    func decrement() {
        if count > 0 {
            count -= 1
        }
    }
    
    func reset() {
        count = 0
    }
}

#Preview {
    ContentView()
}
