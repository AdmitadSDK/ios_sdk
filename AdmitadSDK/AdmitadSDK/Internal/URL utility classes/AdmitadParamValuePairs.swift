//
//  AdmitadParamValuePairs.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 28.09.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

// NOTE: A key-value data structure that preserves the order in which the elements were added.
// Supposed to be used only with relatively small element counts.
internal struct AdmitadParamValuePairs {
    var keyValues = [(key: AdmitadParameter, value: String)]()
    var queryItems: [URLQueryItem] {
        return keyValues.map {URLQueryItem(name: $0.key.rawValue,
                                          value: $0.value)}
    }
}

// MARK: subscription
internal extension AdmitadParamValuePairs {
    subscript(param: AdmitadParameter) -> String {
        get {
            return keyValues.first(where: { $0.key == param})?.value ?? ""
        }
        set {
            if let index = keyValues.index(where: { $0.key == param}) {
                keyValues[index] = (key: param, value: newValue)
            } else {
                keyValues.append((key: param, value: newValue))
            }
        }
    }
}
