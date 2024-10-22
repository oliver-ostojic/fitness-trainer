//
//  DaySelectionView.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/13/24.
//

import SwiftUI

struct DaySelectionView: View {
    @Binding var selectedDays: [DayOfWeek]
    @Binding var isChoosingDay: Bool
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isChoosingDay = false
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .padding(.leading, 20)
                                Text("Back")
                            }
                            .font(.system(size: 16))
                            Spacer()
                    }
                    }
                    HStack {
                        Text("Repeat")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .padding(.top, 20)
                List {
                    ForEach(DayOfWeek.allCases, id: \.self) { day in
                        HStack {
                            Text(day.rawValue)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Spacer()
                            if selectedDays.contains(day) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                    .font(.system(size: 16))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // If day is already clicked
                            if selectedDays.contains(day) {
                                selectedDays.removeAll {$0 == day}
                            }
                            else {
                                selectedDays.append(day)
                            }
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .offset(CGSize(width: 0, height: isChoosingDay ? 0: 10))
            .edgesIgnoringSafeArea(.all)
            .padding(.top, 10)
        }
        .zIndex(3)
    }
}

#Preview {
    DaySelectionView(selectedDays: .constant([.monday]), isChoosingDay: .constant(true))
}
