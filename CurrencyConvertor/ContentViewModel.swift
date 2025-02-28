//
//  ContentViewModel.swift
//  CurrencyConvertor
//
//  Created by Kayo on 2025-02-28.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var convertedAmount = 1.0
    @Published var baseAmount = 1.0
    @Published var baseCurrency: CurrencyChoice = .Usa
    @Published var conversionCurrency: CurrencyChoice = .Euro

    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = ""
        return numberFormatter
    }
    
}
