//
//  CurrencyConversionError.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 02/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

enum CurrencyConversionError: Error {
	case exchangeRateUnavailable
	case unexpectedBehaviour
	case requestError
}
