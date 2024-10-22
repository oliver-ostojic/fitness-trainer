//
//  BottomControlRowView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/14/24.
//

import SwiftUI

struct BottomControlRowView: View {
    @Binding var userData: UserData
    var body: some View {
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
                .environmentObject(userData)
            }
        }
    }
}

#Preview {
    BottomControlRowView(userData: .constant(UserData()))
}
