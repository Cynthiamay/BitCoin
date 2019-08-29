//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

//declarando que a classe ira conformar os protocolos, ira mostrar qualquer mensagem do picker
//colocar na classe o modo de funcionar o picker (rolagem)

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var currencySelected = ""
    
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    //define quantos componentes tem dentro do UIPicker
    // no caso uma coluna somente, por isso retorna 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //especificar quantos rows o picker tem, no caso eh igual ao numero de currency, por isso currencyArray.count. é melhor do que contar, caso seja adicionado mais rows, o código quebraria
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return currencyArray.count
    }
    
    //espeficar quais os dados serão adquiridos
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //usar o currency array (titulo do row) e nao somente imprimir o numero do row
        //o codigo a seguir implementa no fim do site a moeda para fazer a conversão, e assim, imprimir o site completo
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        //o código a seguir é responsável por mostrar os símbolos das moedas junto com o valor. 
        currencySelected = currencySymbolArray[row]
        
        //o código a seguir é responsável por mostrar os valores do bitcoin em cada moeda
        getBitcoinData(url: finalURL)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    

    
    
    
    // o código a seguir veio copiado do GetWeather, agora foi editado para o caso desse aplicativo
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }


    // o código a seguir veio copiado do GetWeather, agora foi editado para o caso desse aplicativo
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        
        if let bitcoinResult = json["ask"].double {
            //o código a seguir poderia ser substituído por:
            //bitcoinPrice.Label.text = "\(currencySelected)\(butcoinResult)" 
            bitcoinPriceLabel.text = currencySelected + String(bitcoinResult)
        
        }
        else {
            
            bitcoinPriceLabel.text = "Não disponível"
        }
        
        //updateUIWithWeatherData()
    }
    




}

