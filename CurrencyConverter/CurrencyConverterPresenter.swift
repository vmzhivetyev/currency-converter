//
//  CurrencyConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConverterPresenter {
	
	enum KnownCurrencyISO : String {
		case RUB, USD, EUR
	}
	
	weak var output : CurrencyConverterPresenterOutput?
	
	private let conversionService : CurrencyConversionServiceProtocol
	
	private var lastRequestData : CurrencyConverterViewData?
	
	init(currencyConversionService: CurrencyConversionServiceProtocol) {
		self.conversionService = currencyConversionService
	}
}

extension CurrencyConverterPresenter : CurrencyConverterViewControllerOutput {
	func didLoadView() {
		self.conversionService.fetchCurrencies()
	}
	
	func requestConversion(data: CurrencyConverterViewData) {
		print("""
			
			Request:
			\(data.date)
			\(data.firstSum)
			\(data.firstCurrency)
			\(data.secondSum)
			\(data.secondCurrency)
			
			""")
		
		guard
			let dataFirstCurrency = data.firstCurrency,
			let dataSecondCurrency = data.secondCurrency else {
				return
		}
		
		self.lastRequestData = data
		
		let firstCurrency = ConvertableCurrency(isoCode: dataFirstCurrency.code, name: dataFirstCurrency.name)
		let secondCurrency = ConvertableCurrency(isoCode: dataSecondCurrency.code, name: dataSecondCurrency.name)
		
		let isForward = data.conversionDirection == .forward
		
		let conversionData = CurrencyConversionService.CurrencyConversionData(
			date: data.date,
			sum: isForward ? data.firstSum : data.secondSum,
			fromCurrency: isForward ? firstCurrency : secondCurrency,
			toCurrency: !isForward ? firstCurrency : secondCurrency)
		self.conversionService.convert(data: conversionData)
	}
}

extension CurrencyConverterPresenter : CurrencyConversionServiceDelegate {
	func currencyConversionService(_ service: CurrencyConversionServiceProtocol, didFetch currencies: [ConvertableCurrency]) {
		let currenciesForView = currencies.map { CurrencyInputView.Currency(code: $0.isoCode, name: $0.name) }
		self.output?.showCurrenciesList(currenciesForView)
		
		guard
			let indexOfRUB = currenciesForView.firstIndex(where: { $0.code == KnownCurrencyISO.RUB.rawValue }),
			let indexOfUSD = currenciesForView.firstIndex(where: { $0.code == KnownCurrencyISO.USD.rawValue })
			else {
				return
		}
		self.output?.selectCurrencies(firstIndex: indexOfUSD, secondIndex: indexOfRUB)
		self.output?.showConversion(of: 1, conversionDirection: .forward)
	}
	
	func currencyConversionService(_ service: CurrencyConversionServiceProtocol, didConvert resultSum: Decimal) {
		guard var result = self.lastRequestData else {
			return
		}
		if result.conversionDirection == .forward {
			result.secondSum = resultSum
		} else {
			result.firstSum = resultSum
		}
		self.output?.showSumAfterConversion(data: result)
	}
	
	func currencyConversionService(_ service: CurrencyConversionServiceProtocol,
								   conversionFailedWith error: CurrencyConversionError) {
		self.output?.showError(text: "Exchange rates for\u{00a0}selected date and\u{00a0}currencies are\u{00a0}not\u{00a0}available")
	}
}
