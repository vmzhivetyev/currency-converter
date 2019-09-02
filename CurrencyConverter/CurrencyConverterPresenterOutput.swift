//
//  CurrencyConverterInteractorOutput.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

protocol CurrencyConverterPresenterOutput: class {
	func showDate(picked: Date, minimum: Date, maximum: Date)
	func showCurrenciesList(_ list: [CurrencyInputView.Currency])
	func showSumAfterConversion(data: CurrencyConverterViewData)

	func selectCurrencies(firstIndex: Int, secondIndex: Int)
	func showConversion(of sum: Decimal, conversionDirection: CurrencyConverterViewController.ConversionDirection)
	func showError(text: String)
	func showLoading(_ show: Bool)
}
