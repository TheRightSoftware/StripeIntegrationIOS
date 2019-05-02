//
//  CustomIntegrationViewController.swift
//  StripeIntegrationExample
//
//  Created by Farrukh Javeid on 02/05/2019.
//  Copyright © 2019 The Right Software. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class CustomIntegrationViewController: UIViewController, UITextFieldDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var expiryTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    //MARK:- Properties
    fileprivate let paymentURL: String = "http://localhost:8888/Stripe_Test/stripe_api.php/"
    
    //MARK:- UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- GUI Events
    @IBAction func makePaymentButtonPressed(_ sender: Any) {
        
        
        //card parameters
        let stripeCardParams = STPCardParams()
        stripeCardParams.number = cardNumberField.text
        let expiryParameters = expiryTextField.text?.components(separatedBy: "/")
        stripeCardParams.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
        stripeCardParams.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
        stripeCardParams.cvc = cvvTextField.text
        
        //converting into token
        let config = STPPaymentConfiguration.shared()
        let stpApiClient = STPAPIClient.init(configuration: config)
        stpApiClient.createToken(withCard: stripeCardParams) { (token, error) in
            
            if error == nil {
                
                //Success
                DispatchQueue.main.async {
                    self.createPayment(token: token!.tokenId, amount: 2000)
                }
                
            } else {
                
                //failed
                print("Failed")
            }
        }
    }
    
    @IBAction func tapGestureInvoked(_ sender: Any) {
        view.endEditing(true)
    }
    
    //MARK:- UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //no dots allowed
        if string == "." {
            return false
        }

        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
         
            if textField == cardNumberField {
                if updatedText.count > 16 {
                    return false
                }
            } else if textField == cvvTextField {
                
                if updatedText.count > 3 {
                    return false
                }
            } else if textField == expiryTextField {
                
                if updatedText.count > 5 {
                    return false
                }
            }
            
        }
        return true
    }
    
    //MARK:- Helper Methods
    fileprivate func createPayment(token: String, amount: Float) {
        
        Alamofire.request(paymentURL, method: .post, parameters: ["stripeToken": token, "amount": amount * 100],encoding: JSONEncoding.default, headers: nil).responseString {
            response in
            switch response.result {
            case .success:
                print("Success")
                
                break
            case .failure(let error):
                
                print("Failure")
            }
        }
    }
}
