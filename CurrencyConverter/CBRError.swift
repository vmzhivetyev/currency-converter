//
//  CBRError.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 05/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

enum CBRError: Error {
	case unableToCreateURL
	case conversionRateUnavailable
	case requestError
}
