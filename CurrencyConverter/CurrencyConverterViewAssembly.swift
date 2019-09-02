//
//  CurrencyConverterViewAssembly.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConverterViewAssembly {
	func createViewController() -> UIViewController {
		let viewController = CurrencyConverterViewController()
		
		let cbrService = CBRService()
		let conversionService = CurrencyConversionService(cbrService: cbrService)
		cbrService.delegate = conversionService
		
		let presenter = CurrencyConverterPresenter(currencyConversionService: conversionService)
		conversionService.delegate = presenter
		
		viewController.output = presenter
		presenter.output = viewController
		
		return viewController
	}
}
