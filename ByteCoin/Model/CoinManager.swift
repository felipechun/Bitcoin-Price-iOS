

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR API KEY"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        //Use String concatenation to add the selected currency at the end of the baseURL along with the API key.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // leaving the delegate to take care of the error (to be conformed in the view controller)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                // optional binding to get unwrapped data
                if let unwrappedData = data {
                    if let bitcoinPrice = self.parseJSON(unwrappedData) {
                        let roundedPriceAsString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdateCoinPrice(price: roundedPriceAsString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        
        do {
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //Get rate property from the decoded data.
            let lastPrice = decodedData.rate            
            return lastPrice
            
        } catch {
            //Catch and send errors to delegate method.
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
