//
//  CBRServiceCurrencyValuesCache.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 02/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CBRServiceCurrencyValuesCache {

	private var cachedValues = [String: Decimal]()
	
	private let dateFormatter : DateFormatter
	
	init(dateFormatter: DateFormatter) {
		self.dateFormatter = dateFormatter
	}
	
	private func cacheKey(currency: CBRService.Currency, date: Date) -> String {
		let dateStr = self.dateFormatter.string(from: date)
		return "\(currency.isoCode) \(dateStr)"
	}
	
	func cacheValue(for currency: CBRService.Currency, date: Date, value: Decimal) {
		let key = self.cacheKey(currency: currency, date: date)
		self.cachedValues[key] = value
	}
	
	func getCachedValue(for currency: CBRService.Currency, date: Date) -> Decimal? {
		let key = self.cacheKey(currency: currency, date: date)
		return self.cachedValues[key]
	}
}
