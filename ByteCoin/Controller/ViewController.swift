//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    let errorAlert = UIAlertController(title: "Oops!", message: "Sorry, something went wrong. Please try selecting another currency", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        coinManager.getCoinPrice(for: "AUD")
        
    }
   
}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}

// MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateCoinPrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.present(self.errorAlert, animated: true, completion: nil)
        }
        print(error)
    }
}

