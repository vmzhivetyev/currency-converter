//
//  UIModuleProtocol.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 04/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

protocol UIModuleProtocol: class {
	associatedtype ModuleInput
	var moduleInput: ModuleInput { get }
}
