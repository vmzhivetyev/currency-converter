//
//  Coordinator.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 04/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class Coordinator: NSObject {
	
	let currencyConverterViewAssembly = CurrencyConverterViewAssembly()
	
	func rootViewController() -> UIViewController {
		let module = self.currencyConverterViewAssembly.createModule(output: self)
		let rootViewController = UINavigationController(rootViewController: module)
		return rootViewController
	}
}

extension Coordinator: CurrencyConverterModuleOutput {
	
}
