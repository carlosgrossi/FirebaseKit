//
//  GoogleMobileAds.swift
//  FirebaseKit
//
//  Created by Carlos Grossi on 20/06/17.
//  Copyright © 2017 Carlos Grossi. All rights reserved.
//

import Foundation
import GoogleMobileAds

public struct GoogleMobileAds {
	public static var shared = GoogleMobileAds()
}

// MARK: Setup
public extension GoogleMobileAds {
	
	public func configure(with applicationId:String) {
		GADMobileAds.configure(withApplicationID: applicationId)
	}
	
}

