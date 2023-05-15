//
//  FilterView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-15.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var locationStore: LocationStore
    @Binding var filters: LocationFilters
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category")) {
                    Picker("Category", selection: $filters.category) {
                        ForEach(locationStore.categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Dates")) {
                    DatePicker("From", selection: $filters.startDate, displayedComponents: .date)
                    DatePicker("To", selection: $filters.endDate, displayedComponents: .date)
                }
                
                Section(header: Text("Privacy")) {
                    Toggle("Private Only", isOn: $filters.isPrivate)
                }

                Section(header: Text("Name")) {
                    TextField("Name", text: $filters.name)
                }
            }
            .navigationBarTitle("Filter", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    filters = LocationFilters()
                }, label: {
                    Text("Clear")
                }),
                trailing: Button(action: {
                    print("Current filters: \(filters)")
                    filters.applyFilter = true
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                })
            )
        }
    }
}
