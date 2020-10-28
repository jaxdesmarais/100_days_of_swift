import UIKit
import BraintreeDropIn
import Braintree

class ViewController: UIViewController {
    var clientToken:String!
    let paymentRequestVal = PKPaymentRequest()
    var braintreeClient = BTAPIClient(authorization:"production_by2wqyx6_hmvyjss7dzvn9hsh")
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var payButton: UIButton! {
        didSet {
            payButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -42, bottom: 0, right: 0)
            payButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
            payButton.layer.cornerRadius = payButton.bounds.midY
            payButton.layer.masksToBounds = true
        }
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amountTextField.becomeFirstResponder()
    }
 
    func fetchClientToken() {
        let clientTokenURL = URL(string: "http://localhost:8000/client_token.php")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
 
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)
            print(clientToken!) // print client token to console
            self.showDropIn(clientToken: clientToken!)
            }.resume()
    }
 
    @IBAction func pay(_ sender: Any) {
        fetchClientToken()
    }
 
    func showDropIn(clientToken: String) {
         let request =  BTDropInRequest()
         request.applePayDisabled = false // Make sure that applePayDisabled is false
 
         let dropIn = BTDropInController.init(authorization: clientToken, request: request) { (controller, result, error) in
 
             if (error != nil) {print("ERROR")}
             else if (result?.isCancelled == true) {
                 controller.dismiss(animated: true, completion: nil)}
             else if let result = result{
                 switch result.paymentOptionType {
                 case .applePay ,.payPal,.masterCard,.discover,.visa:
                     // Here Result success  check paymentMethod not nil if nil then user select applePay
                     if result.paymentMethod != nil{
                         //paymentMethod.nonce  You can use  nonce now
                         //controller.dismiss(animated: true, completion: nil)
                         let paymentmethod = result.paymentMethod?.nonce
                        self.sendRequestPaymentToServer(nonce: paymentmethod!, amount: "10")
                         controller.dismiss(animated: true, completion: nil)
                     }
                     else{
                         controller.dismiss(animated: true, completion: {
                             self.braintreeClient = BTAPIClient(authorization: clientToken)
                             // call apple pay
                             let paymentRequest = self.paymentRequest()
                             if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
                                 as PKPaymentAuthorizationViewController? {
                                vc.delegate = self as? PKPaymentAuthorizationViewControllerDelegate
                                 self.present(vc, animated: true, completion: nil)
                             }
                             else{print("Error: Payment request is invalid.")}
                         })
                     }
                 default:
                     controller.dismiss(animated: true, completion: nil)
                 }
             }
             else{controller.dismiss(animated: true, completion: nil)}
         }
        DispatchQueue.main.sync {
             self.present(dropIn!, animated: true, completion: nil)
        }
     }
 
    func sendRequestPaymentToServer(nonce: String, amount: String) {
        activityIndicator.startAnimating()
 
     let paymentURL = URL(string: "http://localhost:8000/pay.php")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(nonce)&amount=\(amount)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
 
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) -> Void in
            guard let data = data else {
                self?.show(message: error!.localizedDescription)
                return
            }
 
         guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let success = result?["success"] as? Bool, success == true else {
                self?.show(message: "Transaction failed. Please try again.")
                return
            }
                // print the result to the console
                print(result!);
            self?.show(message: "Successfully charged. Thanks So Much :)")
            }.resume()
    }
 
    func show(message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
 
            let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func paymentRequest() -> PKPaymentRequest {
        paymentRequestVal.supportedNetworks = [PKPaymentNetwork.amex, PKPaymentNetwork.visa, PKPaymentNetwork.masterCard];
        paymentRequestVal.merchantCapabilities = PKMerchantCapability(rawValue: PKMerchantCapability.RawValue(UInt8(PKMerchantCapability.capability3DS.rawValue) | UInt8(PKMerchantCapability.capabilityEMV.rawValue)))
        paymentRequestVal.countryCode = "US" // e.g. US
        paymentRequestVal.currencyCode = "USD" // e.g. USD
        paymentRequestVal.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Items", amount: NSDecimalNumber(string: "10")),
            PKPaymentSummaryItem(label: "RunRunFresh", amount: NSDecimalNumber(string: "5"))
        ]
        return paymentRequestVal
    }
}
