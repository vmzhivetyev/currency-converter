//
//  CurrencyConverterViewAssembly.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConverterViewAssembly {
	func createModule(output: CurrencyConverterModuleOutput) -> CurrencyConverterUIModule {

		let cbrService = CBRService()
		let conversionService = CurrencyConversionService(cbrService: cbrService)
		cbrService.delegate = conversionService

		let presenter = CurrencyConverterPresenter(currencyConversionService: conversionService)
		conversionService.delegate = presenter
		
		let viewController = CurrencyConverterViewController(presenter: presenter, moduleInput: presenter)
		presenter.view = viewController
		presenter.moduleOutput = output

		return viewController
	}
}
