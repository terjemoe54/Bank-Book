//
//  Bank_BookApp.swift
//  Bank Book
//
//  Created by Terje Moe on 25/10/2025.
//

import SwiftUI
import SwiftData

@main
struct Bank_BookApp: App {
    var body: some Scene {
        WindowGroup {
            BankListView()
                .modelContainer(for: BankModel.self)
        }
    }
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
