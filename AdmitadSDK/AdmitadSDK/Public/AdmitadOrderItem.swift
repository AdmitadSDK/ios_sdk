//
//  AdmitadOrderItem.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 05.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

/**
 Represents a product for sale. Can be used to construct AditadOrder.
 */
public class AdmitadOrderItem: NSObject, Codable {
    /**
     Item's name.
     */
    @objc public let name: String
    /**
     Quantity of items.
     */
    @objc public let quantity: Int

    @objc public init(name: String,
                quantity: Int = 1) {
        self.name = name
        self.quantity = quantity
    }
}
