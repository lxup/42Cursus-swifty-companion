//
//  UserLevelBarView.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 14/05/2025.
//

import SwiftUI

struct UserLevelBarView: View {
    var level: Double
    @State private var animatedProgress: Double = 0
    @State private var previousLevel: Double = 0

    var percent: Double {
        let fractional = level - floor(level)
        return min(max(fractional * 100, 0), 100)
    }

    var body: some View {
        ProgressView(value: animatedProgress, total: 100) {
            Text("\(Int(percent))%")
                .fontWeight(.semibold)
        }
        .onAppear {
            previousLevel = level
            animateToLevel()
        }
        .onChange(of: level) {
            if previousLevel != level {
                previousLevel = level
                animateToLevel()
            }
        }
    }

    func animateToLevel() {
        animatedProgress = 0
        let target = percent
        let duration = 1.5
        let steps = 60.0
        let stepDuration = 1.0 / steps
        var currentTime: Double = 0.0

        Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            let t = min(currentTime / duration, 1.0)
            let easedT = 0.5 * (1 - cos(.pi * t))
            animatedProgress = target * easedT

            currentTime += stepDuration
            if t >= 1.0 {
                animatedProgress = target
                timer.invalidate()
            }
        }
    }
}

#Preview {
    UserLevelBarView(level: 11.39)
}
