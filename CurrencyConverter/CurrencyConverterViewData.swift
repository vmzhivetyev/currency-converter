//
//  CurrencyConverterViewData.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

struct CurrencyConverterViewData {
	let date: Date
	let firstSum: Decimal
	let firstCurrency: CurrencyInputView.Currency?
	let secondSum: Decimal
	let secondCurrency: CurrencyInputView.Currency?
	let conversionDirectioin: CurrencyConverterViewController.ConversionDirection
}
