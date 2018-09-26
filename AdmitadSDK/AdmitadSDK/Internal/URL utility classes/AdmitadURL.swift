//
//  AdmitadURL.swift
//  AdmitadSDK
//
//  Created by Dmitry Cherednikov on 04.10.17.
//  Copyright © 2017 tachos. All rights reserved.
//

import Foundation

// MARK: - Admitad URL constants
internal struct AdmitadURL {
	static let `default` = "https://ad.admitad.com/tt"
	static let deviceinfoTracking = "https://artfut.com/dedup_ios"
}

internal extension AdmitadURL {
	static func requestURL(params: AdmitadParamValuePairs, apiUrl: String = AdmitadURL.default) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.queryItems = params.queryItems
		
		return URL(string: apiUrl + "?" + urlComponents.percentEncodedQuery!)!
    }
}
