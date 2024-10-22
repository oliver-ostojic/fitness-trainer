//
//  FitnessTrainerApp.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/10/24.
//

import SwiftUI

@main
struct FitnessTrainerApp: App {
    @StateObject private var userData = UserData()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .environmentObject(userData)
                WorkoutView()
                    .tabItem {
                        Label("Workout", systemImage: "figure.strengthtraining.traditional")
                    }
                    .environmentObject(userData)
                StatisticsView()
                    .tabItem {Label("Statistics", systemImage: "chart.bar.xaxis")
                }
                    .environmentObject(userData)
            }
        }
    }
}
