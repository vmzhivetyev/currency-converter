//
//  CBRCurrency.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 05/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import UIKit

struct CBRCurrency: Equatable {
	let id: String
	let isoCode: String
	let name: String
	let engName: String?
	let nominal: String?
	let parentCode: String?

	static func == (lhs: CBRCurrency, rhs: CBRCurrency) -> Bool {
		return lhs.isoCode == rhs.isoCode
	}
}
