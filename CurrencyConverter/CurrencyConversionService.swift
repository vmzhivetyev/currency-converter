//
//  CurrencyConversionService.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConversionService {

	private class ConversionResult {
		
		var fromCurrencyValue: Decimal = -1
		var toCurrencyValue: Decimal = -1
		let conversionData: CurrencyConversionData
		
		init(conversionData: CurrencyConversionData) {
			self.conversionData = conversionData
		}
		
		var sum : Decimal? {
			guard let ratio = self.ratio else {
				return nil
			}
			return self.conversionData.sum * ratio
		}

		var ratio: Decimal? {
			guard self.fromCurrencyValue > 0 && self.toCurrencyValue > 0 else {
				return nil
			}
			return self.fromCurrencyValue / self.toCurrencyValue
		}
	}

	weak var delegate: CurrencyConversionServiceDelegate?

	private let cbrService: CBRServiceProtocol

	private var currenciesList: [CBRCurrency] = []
	private var conversionResult: ConversionResult?
	
	private var dataTasksQueue = [URLSessionDataTask]()

	init(cbrService: CBRServiceProtocol) {
		self.cbrService = cbrService
	}
	
	func cancelPreviousCurrencyValueDataTasks() {
		self.dataTasksQueue.forEach { $0.cancel() }
		self.dataTasksQueue.removeAll()
	}
	
	func enqueueCurrencyValueDataTask(_ dataTask: URLSessionDataTask?) {
		guard let task = dataTask else {
			return
		}
		self.dataTasksQueue.append(task)
	}
}

extension CurrencyConversionService: CurrencyConversionServiceProtocol {
	func fetchCurrencies() {
		self.cbrService.fetchCurrenciesList()
	}

	func convert(data: CurrencyConversionData) {
		guard
			let fromCurrency = self.currenciesList.first(where: { $0.isoCode == data.fromCurrency.isoCode }),
			let toCurrency = self.currenciesList.first(where: { $0.isoCode == data.toCurrency.isoCode })
			else {
			return
		}

		guard fromCurrency != toCurrency else {
			self.delegate?.currencyConversionService(self, didConvert: data.sum)
			return
		}
		
		self.conversionResult = ConversionResult(conversionData: data)

		self.cancelPreviousCurrencyValueDataTasks()
		let task1 = self.cbrService.fetchCurrencyValue(fromCurrency, date: data.date)
		let task2 = self.cbrService.fetchCurrencyValue(toCurrency, date: data.date)
		self.enqueueCurrencyValueDataTask(task1)
		self.enqueueCurrencyValueDataTask(task2)
	}
}

extension CurrencyConversionService: CBRServiceDelegate {
	func cbrService(_ cbrService: CBRServiceProtocol, didFetch currencies: [CBRCurrency]) {
		self.currenciesList = currencies
		let list = currencies.map { ConvertableCurrency(isoCode: $0.isoCode, name: $0.name) }
		self.delegate?.currencyConversionService(self, didFetch: list)
	}

	func cbrService(_ cbrService: CBRServiceProtocol,
					didFetch value: Decimal,
					for currency: CBRCurrency,
					date: Date,
					error: CBRError?) {
		guard
			let result = self.conversionResult,
			date == result.conversionData.date else {
				return
		}
		
		switch currency.isoCode {
		case result.conversionData.fromCurrency.isoCode:
			result.fromCurrencyValue = value
		case result.conversionData.toCurrency.isoCode:
			result.toCurrencyValue = value
		default:
			return
		}
		
		if value <= 0 {
			self.delegate?.currencyConversionService(self, conversionFailedWith: .exchangeRateUnavailable)
			self.conversionResult = nil
			return
		}
		
		if error != nil {
			self.delegate?.currencyConversionService(self, conversionFailedWith: .requestError)
			self.conversionResult = nil
			return
		}
		
		if let resultSum = result.sum {
			self.delegate?.currencyConversionService(self, didConvert: resultSum)
			self.conversionResult = nil
		}
	}
}
