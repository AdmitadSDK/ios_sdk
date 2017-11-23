//
//  URL+Extraction.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 06.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

internal extension URL {
    internal subscript(key: String) -> String? {
        get {
           return queryItemsDictionary()?[key]
        }
    }
}

private extension URL {
    func queryItemsDictionary() -> [String: String]? {
        let components = URLComponents(string: self.absoluteString)

        guard let queryItems = components?.queryItems else {
            return nil
        }

        var dictionary = [String: String]()

        for item in queryItems {
            dictionary[item.name] = item.value ?? ""
        }
        
        return dictionary
    }
}
