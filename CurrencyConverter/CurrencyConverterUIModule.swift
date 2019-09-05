//
//  CurrencyConverterUIModule.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 04/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

class CurrencyConverterUIModule: UIViewController, UIModuleProtocol {
	typealias ModuleInput = CurrencyConverterModuleInput
	var moduleInput: ModuleInput

	init(moduleInput: ModuleInput) {
		self.moduleInput = moduleInput

		super.init(nibName: nil, bundle: nil)
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("init(nibName:, bundle:) has not been implemented")
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
