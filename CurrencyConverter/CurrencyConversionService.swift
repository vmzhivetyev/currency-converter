//
//  CurrencyConversionService.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConversionService {

	struct Currency {
		let isoCode: String
		let name: String
	}

	struct CurrencyConversionData {
		let date: Date
		let sum: Decimal
		let fromCurrency: Currency
		let toCurrency: Currency
	}

	private struct ConversionResult {
		var fromCurrencyValue: Decimal = -1
		var toCurrencyValue: Decimal = -1

		var ratio: Decimal {
			guard self.isFilled else {
				return -1
			}
			guard toCurrencyValue != 0 else {
				return 0
			}
			return fromCurrencyValue / toCurrencyValue
		}

		private var isFilled: Bool {
			return fromCurrencyValue >= 0 && toCurrencyValue >= 0
		}
	}

	weak var delegate: CurrencyConversionServiceDelegate?

	private let cbrService: CBRServiceProtocol

	private var currenciesList: [CBRService.Currency] = []
	private var conversionData: CurrencyConversionData?
	private var conversionResult = ConversionResult()
	
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
		self.conversionData = data
		self.conversionResult = ConversionResult()

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
		self.cancelPreviousCurrencyValueDataTasks()
		let task1 = self.cbrService.fetchCurrencyValue(fromCurrency, date: data.date)
		let task2 = self.cbrService.fetchCurrencyValue(toCurrency, date: data.date)
		self.enqueueCurrencyValueDataTask(task1)
		self.enqueueCurrencyValueDataTask(task2)
	}
}

extension CurrencyConversionService: CBRServiceDelegate {
	func cbrService(_ cbrService: CBRService, didFetch currencies: [CBRService.Currency]) {
		self.currenciesList = currencies
		let list = currencies.map { CurrencyConversionService.Currency(isoCode: $0.isoCode, name: $0.name) }
		self.delegate?.currencyConversionService(self, didFetch: list)
	}

	func cbrService(_ cbrService: CBRService,
					didFetch value: Decimal,
					for currency: CBRService.Currency,
					error: CBRService.CBRError?) {
		guard let data = self.conversionData else {
			self.delegate?.currencyConversionService(self, conversionFailedWith: .unexpectedBehaviour)
			return
		}

		if currency.isoCode == data.fromCurrency.isoCode {
			self.conversionResult.fromCurrencyValue = value
		}
		if currency.isoCode == data.toCurrency.isoCode {
			self.conversionResult.toCurrencyValue = value
		}

		let ratio = self.conversionResult.ratio
		guard ratio >= 0 else {
			return
		}

		if ratio > 0 {
			let result = data.sum * ratio
			self.delegate?.currencyConversionService(self, didConvert: result)
		} else {
			if error == .conversionRateUnavailable {
				self.delegate?.currencyConversionService(self, conversionFailedWith: .exchangeRateUnavailable)
			} else {
				self.delegate?.currencyConversionService(self, conversionFailedWith: .requestError)
			}
		}
	}
}
