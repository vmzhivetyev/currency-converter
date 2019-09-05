//
//  CurrencyConversionServiceProtocol.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

protocol CurrencyConversionServiceProtocol {
	func fetchCurrencies()
	func convert(data: CurrencyConversionData)
}
