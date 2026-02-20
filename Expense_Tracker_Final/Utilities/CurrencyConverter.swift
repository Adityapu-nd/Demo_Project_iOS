import Foundation
import Combine

class CurrencyConverter: ObservableObject {
    @Published var rates: [String: Double] = ["INR": 1.0]
    static let shared = CurrencyConverter()
    private let apiKey = "ed43f6608a579e4e1606d5b7e4dbd23a" // Replace with your real API key
    private let ratesURL = "https://api.exchangeratesapi.io/v1/latest?access_key=API_KEY"

    private init() {
        fetchRates()
    }

    func fetchRates() {
        guard let url = URL(string: ratesURL.replacingOccurrences(of: "API_KEY", with: apiKey)) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let ratesDict = json["rates"] as? [String: Double] {
                DispatchQueue.main.async {
                    self.rates = ratesDict
                }
            }
        }
        task.resume()
    }

    func convertToINR(amount: Double, from currency: String) -> Double {
        guard let eurToInr = rates["INR"], let eurToFrom = rates[currency] else { return amount }
        // All rates are relative to EUR, so amount in EUR = amount / eurToFrom, then to INR = * eurToInr
        let amountInEUR = amount / eurToFrom
        let amountInINR = amountInEUR * eurToInr
        return amountInINR
    }
}
