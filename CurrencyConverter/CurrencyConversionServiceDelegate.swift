//
//  CurrencyConversionServiceDelegate.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import Foundation


protocol CurrencyConversionServiceDelegate: class {
	func currencyConversionService(_ service: CurrencyConversionServiceProtocol,
								   didFetch currencies: [ConvertableCurrency])
	
	func currencyConversionService(_ service: CurrencyConversionServiceProtocol,
								   didConvert resultSum: Decimal)
	
	func currencyConversionService(_ service: CurrencyConversionServiceProtocol,
								   conversionFailedWith error: CurrencyConversionError)
}
