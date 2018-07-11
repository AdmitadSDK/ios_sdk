//
//  AdmitadOrder.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 28.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

/**
 Contains information on an order used for tracking such events as Register, Confirmed Purchase and Paid Order.
 */
public class AdmitadOrder: NSObject {
    /**
     Order's identifier. Correspods to oid parameter of Admitad API.
     */
    @objc public let id: String
    /**
     Price of all items included in order.
     */
    @objc public let totalPrice: String
    /**
     ISO 4217 code of the currency in which price is defined.
     */
    @objc public let currencyCode: String
    /**
     Array of items included in the order.
     */
    @objc public let items: [AdmitadOrderItem]
    /**
     Additional info that can be sent with event related to the order.
     Corresponds to json parameter of Admitad API.
     */
    @objc public let userInfo: [String: String]?
    
    /**
     Tarif code to set price alterations depending on item or order type.
    */
    @objc public let tarifCode: String?

    /**
     Promocode will be shown in order analytics.
    */
    @objc public let promocode: String?
    
    @objc public init(id: String,
                totalPrice: String,
                currencyCode: String,
                items: [AdmitadOrderItem],
                userInfo: [String: String]? = nil,
                tarifCode: String? = nil,
                promocode: String? = nil)
    {
        self.id = id
        self.totalPrice = totalPrice
        self.currencyCode = currencyCode
        self.items = items
        self.userInfo = userInfo
        self.tarifCode = tarifCode
        self.promocode = promocode
    }
}

internal extension AdmitadOrder {
    convenience init?(url: URL) {
        guard let id = url[AdmitadParameter.admitadUid.rawValue] else {
            return nil
        }
        guard let price = url[AdmitadParameter.price.rawValue] else {
            return nil
        }
        guard let currencyCode = url[AdmitadParameter.currencyCode.rawValue] else {
            return nil
        }
        guard let json = AdmitadJsonParameter(url: url) else {
            return nil
        }
        guard let tarifCode = url[AdmitadParameter.tarifcode.rawValue] else {
            return nil
        }
        guard let promocode = url[AdmitadParameter.promocode.rawValue] else {
            return nil
        }

        let items = json.items
        let userInfo = json.userInfo
        
        self.init(id: id,
                  totalPrice: price,
                  currencyCode: currencyCode,
                  items: items,
                  userInfo: userInfo,
                  tarifCode: tarifCode,
                  promocode: promocode)
    }
}

internal extension AdmitadOrder {
    var json: String {
        let jsonEncoder = JSONEncoder()
        let json = AdmitadJsonParameter(items: items,
                               userInfo: userInfo)
        do {
            let data = try jsonEncoder.encode(json)
            return String(data: data, encoding: .utf8) ?? ""
        }
        catch {
            return ""
        }
    }
}
