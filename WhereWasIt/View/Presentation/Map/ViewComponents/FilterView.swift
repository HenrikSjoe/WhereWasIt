//
//  FilterView.swift
//  WhereWasIt
//
//  Created by Henrik Sjögren on 2023-05-15.
//

import SwiftUI

struct FilterView: View {
    @Binding var filters: LocationFilters
    @Binding var selectedCategory: LocationCategory
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(LocationCategory.allCases, id: \.self) { category in
                            Text(category.rawValue)
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
                    filters.applyFilter = true
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Done")
                })
            )
        }
    }
}
