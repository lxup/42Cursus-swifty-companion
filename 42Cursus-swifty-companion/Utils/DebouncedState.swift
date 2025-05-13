//
//  DebounceText.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 13/05/2025.
//

import SwiftUI

class DebouncedState<T>: ObservableObject {
    @Published var value: T
    @Published var debouncedValue: T
    
    init(initialValue: T, delay: Double = 0.3) {
        _value = Published(initialValue: initialValue)
        _debouncedValue = Published(initialValue: initialValue)
        
        $value
            .debounce(for: .seconds(delay), scheduler: RunLoop.main)
            .assign(to: &$debouncedValue)
    }
}
