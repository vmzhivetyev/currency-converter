//
//  CurrencyConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConverterPresenter {
	
	weak var output : CurrencyConverterPresenterOutput?
}

extension CurrencyConverterPresenter : CurrencyConverterViewControllerOutput {
	func requestConversion(data: CurrencyConverterViewData) {
		print("""
			
			Request:
			\(data.date)
			\(data.firstSum)
			\(data.firstCurrency)
			\(data.secondSum)
			\(data.secondCurrency)
			
			""")
		
		let result = CurrencyConverterViewData(date: data.date,
											   firstSum: data.firstSum,
											   firstCurrency: data.firstCurrency,
											   secondSum: data.firstSum * 3.33333,
											   secondCurrency: CurrencyInputView.Currency(code: "LOL"),
											   conversionDirectioin: .forward)
		
		self.output?.currencyWasConverted(data: result)
	}
}
