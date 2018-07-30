

import UIKit
import Alamofire
import SwiftyJSON

// Çok Önemli Not: CocoaPods ların kurulumu terminalden yapıldıktan sonra Xcode programının kapatılıp tekrardan açılması gerekiyor. Yoksa hata veriyor. Pods Workspace dosyası görünüyor(mavi) fakat BitconTicker workspace dosyası görünmüyor.
class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["TRY","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var currencySelected = ""
    let currencySymbol = ["₺","$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    // to determine how many columns we want in our picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // how many rows this picker should have
    // We are programmers. We don’t have the time to count the number of currencies we need to display. Let’s use the count method to get that information.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //TODO: Place your 3 UIPickerView delegate methods here
    // Şimdi picker in içini titleForRow methodunu kullanarak arraydaki stringler ile dolduruyoruz.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    // user bir row seçtiğinde picker a ne yapılacağını söylüyoruz. Şimdi row indexini yansıtıyoruz.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // row kısmını burada yansıtıyoruz.
        print(row)
        // Sembolünü yansıtmak için currency index ile symbol index i eşleştiriyoruz.
        currencySelected = currencySymbol[row]
        // index içeriğini burada yansıtıyoruz
        let location = currencyArray[row]
        print(location)
        // son url herhalde aşağıdaki formatta olması gerekiyor. baseURL e picker dan gelen string API a gönderilecek. 
        finalURL = baseURL + currencyArray[row]
        getBitcoin(url: finalURL)
        
    }

    //MARK: - Networking
    /***************************************************************/

    
    func getBitcoin(url: String) {
    
        Alamofire.request(url, method: .get).responseJSON{ response in
            
            if response.result.isSuccess{
                print("Sucess! Got the bitcoin data")
                let bitcoinValue : JSON = JSON(response.result.value!)
                
                self.updateBitcoinData(json: bitcoinValue)

                
            }else {
                print("Error: \(String(describing: response.result.error))")
                
            }
            
        }
        
    }
    
    func updateBitcoinData(json : JSON) {
        
        if let bitCoinResult = json["last"].double {
            bitcoinPriceLabel.text = currencySelected + " " + String(bitCoinResult)
            
        }else{
            bitcoinPriceLabel.text = "Fiyat bulunamadı"
            
        }
        
        
    }
    
    }
   








