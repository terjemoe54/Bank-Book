//
//  ContentView.swift
//  Bank Book
//
//  Created by Terje Moe on 25/10/2025.
//

import SwiftUI
import SwiftData

struct BankListView: View {
    @Environment(\.modelContext) private var modelContext
   
    @Query(sort: [SortDescriptor(\BankModel.date)])
     var datePayments: [BankModel]
    
    @Query(sort: [SortDescriptor(\BankModel.name)])
     var namePayments: [BankModel]
    
    // Completed Payments for name
   
    @Query(
        filter: #Predicate<BankModel> { $0.isCompleted == true },
        sort: [SortDescriptor(\BankModel.name)]
    )
    var completedNamePayment : [BankModel]
    
    // Completed Payments for date
    
    @Query(
        filter: #Predicate<BankModel> { $0.isCompleted == true },
        sort: [SortDescriptor(\BankModel.date)]
    )
    var completedDatePayment : [BankModel]
   
    
    @State private var showCompletedOnly: Bool = false
    
    @State private var newName: String = ""
    @State private var selectedSortOption: SortOption = .byName
    @State private var selectedDate = Date()
    
    enum SortOption: String, CaseIterable {
        case byName = "By Name"
        case byDate = "By Date"
    }
   
    private var sortedPayments: [BankModel] {
        switch selectedSortOption {
        case .byName:
            showCompletedOnly ? completedNamePayment : namePayments
            case .byDate:
            showCompletedOnly ? completedDatePayment : datePayments
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("tanpo")
                    .resizable()
                    .scaledToFit()
                VStack {
                    // Textfield
                    HStack {
                        TextField("New Payment", text: $newName)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            addPayment()
                        } label: {
                            Text("Add")
                                .padding()
                                .background(.blue)
                                .clipShape(.rect(cornerRadius: 10))
                                .foregroundStyle(.white)
                        }
                      }
                    
                    // Date Picker
                    DatePicker(
                        "Selected Date",
                         selection: $selectedDate,
                         in: Date()... )
                    
                    // Segmented Picker
                    Picker(
                        "Sort Payments",
                        selection: $selectedSortOption) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue)
                                    .tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    
                    // Toggle Completion
                    Toggle("Show Completed Only", isOn: $showCompletedOnly)
                    
                }
                .padding()
                // List
                List(sortedPayments) { payment in
                    HStack {
                        Button {
                            toggleCompletion(payment)
                        } label: {
                            Image(systemName:
                          payment.isCompleted ? "checkmark.circle" : "circle")
                            .font(.caption)
                            .foregroundStyle(payment.isCompleted ? .green : .gray)
                        }

                        
                        Text(payment.name)
                            .foregroundStyle(payment.isCompleted ? .gray : .blue)
                            .strikethrough(payment.isCompleted, color: .gray)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(payment.date, style: .date)
                            //   Text(payment.amounth)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            deletePayment(payment)
                        } label: {
                            Label(
                                "Delete",
                                systemImage: "trash")
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Payments")
        }
    }
   
    private func addPayment() {
        guard newName.count >= 2  else {
            print("The name must have at least 2 characters")
            return
        }
        let newPayment = BankModel(
            name: newName,
            date: selectedDate
        //    amount: 0.00
            )
        modelContext.insert(newPayment)
        
        do {
            try modelContext.save()
        } catch {
            print("Could not save record \(error.localizedDescription)")
        }
        
        newName = ""
        selectedDate = Date()
        
    }
    
    private func deletePayment(_ payment: BankModel) {
        modelContext.delete(payment)
        try? modelContext.save()
    }
    
    private func toggleCompletion(_ payment: BankModel) {
        payment.isCompleted.toggle()
        try? modelContext.save()
    }
    
}

#Preview {
    BankListView()
        .modelContainer(for: BankModel.self)
}
