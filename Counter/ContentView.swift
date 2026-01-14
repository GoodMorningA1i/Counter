//
//  ContentView.swift
//  Counter
//
//  Created by Ali Syed on 2025-12-01.
//

import AVFAudio
import SwiftUI

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var showingResetConfirmation = false
    @State private var count: Int {
        didSet {
            if let encoded = try? JSONEncoder().encode(count) {
                UserDefaults.standard.set(encoded, forKey: "Count")
            }
        }
    }
    @State private var isEditing = false
    @State private var editingValue = ""
    @State private var textFaded = false
    @FocusState private var isTextFieldFocused: Bool
    
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
            VStack {
                if isEditing {
                    TextField("", text: $editingValue)
                        .keyboardType(.numberPad)
                        .font(.system(size: 100))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .multilineTextAlignment(.center)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            commitEditing()
                        }
                        .onDisappear {
                            isEditing = false
                            isTextFieldFocused = false
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    commitEditing()
                                }
                            }
                        }
                } else {
                    Text("\(count)")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .foregroundColor(.primary)
                        .font(.system(size: 100))
                        .opacity(textFaded ? 0.2 : 1)
                        .onTapGesture {
                            textFaded = true
                            increment()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                textFaded = false
                            }
                        }
                        .contentTransition(.numericText())
                        .animation(.default, value: count)
                        .sensoryFeedback(.increase, trigger: count)
                        .onLongPressGesture {
                            editingValue = ""
                            isEditing = true
                            isTextFieldFocused = true
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        textFaded = true
                        decrement()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            textFaded = false
                        }
                    } label: {
                        Image(systemName: "minus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingResetConfirmation.toggle()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .confirmationDialog("Counter Reset", isPresented: $showingResetConfirmation) {
                        Button("Yes") { reset() }
                        Button("No") { }
                    } message: {
                        Text("Do you want to reset your counter to 0?")
                    }
                }
            }
        }
    }
    
    func increment() {
        incrementCounter()
        produceCounterSoundEffect(for: CounterType.increment.rawValue)
    }
    
    func decrement() {
        decrementCounter()
        produceCounterSoundEffect(for: CounterType.decrement.rawValue)
    }
    
    func reset() {
        count = 0
    }
    
    private func incrementCounter() {
        count += 1
    }
    
    private func decrementCounter() {
        count -= 1
    }
    
    private func produceCounterSoundEffect(for soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("Couldn't not read the file name \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            // couldn't load file :(
            print("ERROR: \(error.localizedDescription) creating audio player")
        }
    }
    
    private func commitEditing() {
        if let newValue = Int(editingValue) {
            if newValue < 900000 {
                count = newValue
            }
        }
        isEditing = false
        isTextFieldFocused = false
    }
    
    private enum CounterType: String {
        case increment
        case decrement
    }
}

#Preview {
    ContentView()
}
