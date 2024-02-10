//
//  DebouncedState.swift
//  LightCommander
//
//  Created by Martynas Skrebė on 03/01/2024.
//

import SwiftUI

@propertyWrapper
struct DebouncedState<Value>: DynamicProperty {
    @StateObject private var backingState: BackingState<Value>
    
    init(initialValue: Value, delay: Double = 0.3) {
        self.init(wrappedValue: initialValue, delay: delay)
    }
    
    init(wrappedValue: Value, delay: Double = 0.3) {
        self._backingState = StateObject(wrappedValue: BackingState<Value>(originalValue: wrappedValue, delay: delay))
    }
    
    var wrappedValue: Value {
        get {
            backingState.debouncedValue
        }
        nonmutating set {
            backingState.currentValue = newValue
        }
    }
    
    public var projectedValue: Binding<Value> {
        Binding {
            backingState.currentValue
        } set: {
            backingState.currentValue = $0
        }
    }
    
    private class BackingState<T>: ObservableObject {
        @Published var currentValue: T
        @Published var debouncedValue: T
        init(originalValue: T, delay: Double) {
            _currentValue = Published(initialValue: originalValue)
            _debouncedValue = Published(initialValue: originalValue)
            $currentValue
                .debounce(for: .seconds(delay), scheduler: RunLoop.main)
                .assign(to: &$debouncedValue)
        }
    }
}
