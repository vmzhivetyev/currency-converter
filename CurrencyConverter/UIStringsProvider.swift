//
//  UIStringsProvider.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 02/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class UIStringsProvider {
	
	static let shared = UIStringsProvider()
	
	var currencyConverterScreenTitle : String { return "Currency Converter" }
	var selectDateHint : String { return "Выберите дату курса валют" }
	var exchangeRateUnavailable : String { return "Курс обмена для выбранной даты и валюты недоступен" }

}
