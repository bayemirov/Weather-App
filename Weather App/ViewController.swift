//
//  ViewController.swift
//  Weather App
//
//  Created by Beket on 07.07.17.
//  Copyright © 2017 Beket Bayemirov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func getWeatherButton(_ sender: Any) {
        
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var resultMessage = ""
                
                if error != nil {
                    print("Error")
                }
                else {
                    if let unwrappedData  = data {
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let separatedArray1 = dataString?.components(separatedBy: stringSeparator) {
                            if separatedArray1.count > 1 {
                                stringSeparator = "</span>"
                                let separatedArray2 = separatedArray1[1].components(separatedBy: stringSeparator)
                                if separatedArray2.count > 1 {
                                    resultMessage = separatedArray2[0].replacingOccurrences(of: "&deg;", with: "∘")
                                    print(resultMessage)
                                }
                            }
                        }
                    }
                }
                
                if resultMessage == "" {
                    resultMessage = "The weather there couldn't be found. Please try again."
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.resultLabel.text = resultMessage
                    
                })
                
            }
            
            task.resume()
        }
        else {
            resultLabel.text = "The weather there couldn't be found. Please try again."
        }

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

