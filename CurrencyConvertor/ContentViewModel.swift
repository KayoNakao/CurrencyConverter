//
//  ContentViewModel.swift
//  CurrencyConvertor
//
//  Created by Kayo on 2025-02-28.
//

import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    
    @Published var convertedAmount = 1.0
    @Published var baseAmount = 1.0
    @Published var baseCurrency: CurrencyChoice = .Usa
    @Published var conversionCurrency: CurrencyChoice = .Euro
    @Published var rates: Rates?
    @Published var isLoading = true
    @Published var errorMessage = ""
    
    var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = ""
        return numberFormatter
    }
    
    var conversionRate: Double {
        if let rates = rates,
           let baseExchangeRate = rates.rates[baseCurrency.rawValue],
           let conversionExchangeRate = rates.rates[conversionCurrency.rawValue] {
           return conversionExchangeRate / baseExchangeRate
        }
        return 1
    }
    
    func fetchRates() async {
        var apiKey = ""
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            let url = URL(filePath: path)
            let data = try? Data(contentsOf: url)
            guard let data = data,
                  let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: String],
                let key = plist["API_KEY"] else {
                errorMessage = "Could not fetch rates."
                return
            }
            apiKey = key
        }

        guard let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(apiKey)") else {
            errorMessage = "Could not fetch rates."
            print("API url is not valid")
            return
        }
        let urlRequest = URLRequest(url: url)
        isLoading = true
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
             rates = try JSONDecoder().decode(Rates.self, from: data)
            
        } catch {
            errorMessage = "Could not fetch rates."
            print(error.localizedDescription)
        }
        isLoading = false
    }
    
    func convert() {
        if let rates = rates,
           let baseExchangeRate = rates.rates[baseCurrency.rawValue],
           let conversionExchangeRate = rates.rates[conversionCurrency.rawValue] {
            convertedAmount = (conversionExchangeRate / baseExchangeRate) * baseAmount
        }
    }
    
}
