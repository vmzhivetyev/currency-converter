//
//  CurrencyConversionData.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 05/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

struct CurrencyConversionData {
	let date: Date
	let sum: Decimal
	let fromCurrency: ConvertableCurrency
	let toCurrency: ConvertableCurrency
}
