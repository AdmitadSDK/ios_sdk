//
//  ViewController.swift
//  DeeplinkSDKTest
//
//  Created by Dmitry Cherednikov on 26.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import UIKit
import AdmitadSDK

enum CartActionType: String {
    case confirm = "confirm"
    case pay = "pay"
    case none = "none"
}

class CartVC: UIViewController, UITableViewDataSource {
    @IBOutlet weak var rightNavigationBarItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private var currentAction = CartActionType.confirm
    private let currencyCode = "RUB"
    private let admitadTracker = AdmitadTracker.sharedInstance

    private let items: [AdmitadOrderItem] = {
        let item1 = AdmitadOrderItem(name: "Phone")
        let item2 = AdmitadOrderItem(name: "Phone Charger",
                                     quantity: 3)
        let item3 = AdmitadOrderItem(name: "TV",
                                     quantity: 2)
        let item4 = AdmitadOrderItem(name: "USB Flash Drive",
                                     quantity: 4)
        return [item1, item2, item3, item4]
    }()

    private let prices = [3000, 200, 45000, 800]
}

// MARK: UIViewController lifecycle
extension CartVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self

        title = "Cart"
    }
}

// MARK: UITableViewDataSource
extension CartVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseId = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseId)
        if cell == nil {
            cell = UITableViewCell(style: .value1,
                                   reuseIdentifier: reuseId)
        }
        let item = items[indexPath.row]
        
        cell!.textLabel?.text = item.name
        cell!.detailTextLabel?.text = detailText(forRow: indexPath.row)

        return cell!
    }
}

// MARK: actions
private extension CartVC {
    @IBAction func rightNavigationBarItemPressed(_ sender: Any) {
        switch currentAction {
        case .confirm:
            trackConfirmedPurchaseEvent()
        case .pay:
            trackPaidOrderEvent()
        case .none:
            break
        }
    }

    func trackConfirmedPurchaseEvent() {
        spinner.startAnimating()

        admitadTracker.trackConfirmedPurchaseEvent(order: buildOrder())
        {   [weak self] (error) in
            self?.spinner.stopAnimating()

            if error != nil {
                return
            }

            self?.currentAction = .pay
            self?.rightNavigationBarItem.title = CartActionType.pay.rawValue
        }
    }

    func trackPaidOrderEvent() {
        spinner.startAnimating()

        admitadTracker.trackPaidOrderEvent(order: buildOrder())
        {   [weak self] (error) in
            self?.spinner.stopAnimating()

            if error != nil {
                return
            }

            self?.currentAction = .none
            self?.rightNavigationBarItem.isEnabled = false
        }
    }
}

// MARK: - utility methods
private extension CartVC {
    func detailText(forRow row: Int) -> String {
        let item = items[row]
        let price = prices[row]
        return String(item.quantity) + " x " + String(price) +
            " " + currencyCode
    }
}

// MARK: - order building
private extension CartVC {
    func buildOrder() -> AdmitadOrder {
        return AdmitadOrder(id: "123456789",
                            totalPrice: orderPrice(),
                            currencyCode: currencyCode,
                            items: items,
                            userInfo: ["country": "Russia",
                                       "payment_method": "PayPal"], tarifCode: "123", promocode: "")
    }

    func orderPrice() -> String {
        var sum = 0
        for i in 0...3 {
            sum += items[i].quantity * prices[i]
        }
        return String(describing: sum)
    }
}
