//
//  BankModel.swift
//  Bank Book
//
//  Created by Terje Moe on 25/10/2025.
//

import Foundation
import SwiftData

@Model
class BankModel {

    var name: String
    var date: Date
 //   var amounth: Double
    var isCompleted: Bool
    
    init(
        name: String,
        date: Date = Date(),
 //       amounth: Double = 0.00
        isCompleted: Bool = false
    ) {
        self.name = name
        self.date = date
  //      self.amounth = amounth
        self.isCompleted = isCompleted
    }
}
