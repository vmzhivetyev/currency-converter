//
//  CurrencyConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConverterPresenter {

	enum KnownCurrencyISO: String {
		case RUB, USD, EUR
	}

	weak var output: CurrencyConverterPresenterOutput?

	private let conversionService: CurrencyConversionServiceProtocol

	private var lastRequestData: CurrencyConverterViewData?

	init(currencyConversionService: CurrencyConversionServiceProtocol) {
		self.conversionService = currencyConversionService
	}
	
	func retryRequest(_ requestClosure: @escaping () -> ()) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			requestClosure()
		}
	}
}

extension CurrencyConverterPresenter: CurrencyConverterViewControllerOutput {
	func didLoadView() {
		self.conversionService.fetchCurrencies()
		self.output?.showLoading(true)
	}

	func requestConversion(data: CurrencyConverterViewData) {
		guard
			let dataFirstCurrency = data.firstCurrency,
			let dataSecondCurrency = data.secondCurrency else {
				return
		}

		self.lastRequestData = data

		let firstCurrency = CurrencyConversionService.Currency(isoCode: dataFirstCurrency.code,
															   name: dataFirstCurrency.name)
		let secondCurrency = CurrencyConversionService.Currency(isoCode: dataSecondCurrency.code,
																name: dataSecondCurrency.name)

		let isForward = data.conversionDirection == .forward

		let conversionData = CurrencyConversionService.CurrencyConversionData(
			date: data.date,
			sum: isForward ? data.firstSum : data.secondSum,
			fromCurrency: isForward ? firstCurrency : secondCurrency,
			toCurrency: !isForward ? firstCurrency : secondCurrency)
		self.conversionService.convert(data: conversionData)
	}
}

extension CurrencyConverterPresenter: CurrencyConversionServiceDelegate {
	func currencyConversionService(_ service: CurrencyConversionServiceProtocol,
								   didFetch currencies: [CurrencyConversionService.Currency]) {
		// Автоповтор запроса списка валют каждую секунду, если он падает
		if currencies.count <= 1 {
			self.retryRequest { [weak self] in
				self?.conversionService.fetchCurrencies()
			}
			return
		}
		
		let currenciesForView = currencies.map { CurrencyInputView.Currency(code: $0.isoCode, name: $0.name) }
		self.output?.showCurrenciesList(currenciesForView)

		guard
			let indexOfRUB = currenciesForView.firstIndex(where: { $0.code == KnownCurrencyISO.RUB.rawValue }),
			let indexOfUSD = currenciesForView.firstIndex(where: { $0.code == KnownCurrencyISO.USD.rawValue })
			else {
				self.output?.selectCurrencies(firstIndex: 0, secondIndex: 3)
				self.output?.showConversion(of: 1, conversionDirection: .forward)
				self.output?.showLoading(false)
				return
		}
		self.output?.selectCurrencies(firstIndex: indexOfUSD, secondIndex: indexOfRUB)
		self.output?.showConversion(of: 1, conversionDirection: .forward)
		self.output?.showLoading(false)
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
		if case .exchangeRateUnavailable = error {
			self.output?.showError(text: UIStringsProvider.shared.exchangeRateUnavailable)
		} else {
			self.output?.showError(text: UIStringsProvider.shared.requestError)
			// Запрос упал, пробуем еще раз
			self.retryRequest { [weak self] in
				guard let data = self?.lastRequestData else {
					return
				}
				self?.requestConversion(data: data)
			}
		}
	}
}
