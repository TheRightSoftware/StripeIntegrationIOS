//
//  StanadardIntegrationViewController.swift
//  StripeIntegrationExample
//
//  Created by Farrukh Javeid on 29/04/2019.
//  Copyright © 2019 The Right Software. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class StanadardIntegrationViewController: UIViewController, STPAddCardViewControllerDelegate {

    //MARK:- Properties
    fileprivate let paymentURL: String = "http://localhost:8888/Stripe_Test/stripe_api.php/"

    //MARK:- UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- GUI Events
    @IBAction func setupCardButtonPressed(_ sender: Any) {
        
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .full
        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- STPAdd Card Controller Delegate
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
                self.createPayment(token: token.tokenId, amount: 1000)
        }
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

