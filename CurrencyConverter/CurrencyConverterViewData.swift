//
//  CurrencyConverterViewData.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

struct CurrencyConverterViewData {
	var date: Date
	var firstSum: Decimal
	var firstCurrency: CurrencyInputView.Currency?
	var secondSum: Decimal
	var secondCurrency: CurrencyInputView.Currency?
	var conversionDirection: CurrencyConverterViewController.ConversionDirection
}
