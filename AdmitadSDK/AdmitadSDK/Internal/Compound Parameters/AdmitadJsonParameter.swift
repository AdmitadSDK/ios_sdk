//
//  AdmitadJSON.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 20/10/2017.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

// TODO: check quotes shielding
internal struct AdmitadJsonParameter: Codable {
    let items: [AdmitadOrderItem]
    let userInfo: [String: String]?
}

// MARK: keys
internal extension AdmitadJsonParameter {
    enum CodingKeys: String, CodingKey {
        case items
        case userInfo = "user_info"
    }
}

// MARK: initialization
internal extension AdmitadJsonParameter {
    init?(url: URL) {
        guard let jsonString = url[AdmitadParameter.json.rawValue] else {
            return nil
        }
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            let jsonDecoder = JSONDecoder()
            let decodedSelf = try jsonDecoder.decode(AdmitadJsonParameter.self,
                                                     from: data)
            self.init(items: decodedSelf.items,
                      userInfo: decodedSelf.userInfo)
        }
        catch {
            return nil
        }
    }
}
