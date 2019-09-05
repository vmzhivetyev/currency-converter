//
//  CBRService.swift
//  CurrencyConverter
//
//  Created by Вячеслав Живетьев on 01/09/2019.
//  Copyright © 2019 Вячеслав Живетьев. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class CBRService {

	private enum CBRURL: String {
		static let host = "https://www.cbr.ru"

		case currenciesList = "scripts/XML_valFull.asp"
		case currencyValue = "scripts/XML_dynamic.asp"
	}

	static let rubCurrency = CBRCurrency(id: "",
										 isoCode: "RUB",
										 name: "Российский рубль",
										 engName: "Russian ruble",
										 nominal: "1",
										 parentCode: "")

	weak var delegate: CBRServiceDelegate?

	private let urlSession = URLSession.shared
	// swiftlint:disable:next force_unwrapping
	private let baseURL = URL(string: CBRURL.host)!

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter
	}()

	private var cache = [String: Decimal]()

	func cacheKey(_ currency: CBRCurrency, _ date: Date) -> String {
		let dateStr = self.dateFormatter.string(from: date)
		return "\(currency.isoCode) \(dateStr)"
	}

	private func url(_ cbrURL: CBRURL, parameters: [String: String]) -> URL? {
		let urlWithoutParameters = baseURL.appendingPathComponent(cbrURL.rawValue)
		var urlComponents = URLComponents(url: urlWithoutParameters, resolvingAgainstBaseURL: true)
		urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
		return urlComponents?.url
	}

	@discardableResult
	private func xmlFromUrl(_ cbrURL: CBRURL,
							parameters: [String: String],
							completion: @escaping (XML.Accessor?, Error?) -> Void) -> URLSessionDataTask? {
		guard let fullURL = self.url(cbrURL, parameters: parameters) else {
			print("Error: Unable to create url")
			completion(nil, CBRError.unableToCreateURL)
			return nil
		}

		print("Doing request at URL:\n  \(fullURL)")
		let dataTask = self.urlSession.dataTask(with: fullURL) { (data, _, error) in
			guard let data = data else {
				completion(nil, error)
				return
			}
			completion(XML.parse(data), error)
		}
		// simulating slow connection
//		DispatchQueue.global(qos: .userInitiated).async {
//			sleep(5)
//			dataTask.resume()
//		}
		dataTask.resume()
		return dataTask
	}
}

extension CBRService: CBRServiceProtocol {
	func fetchCurrenciesList() {
		self.xmlFromUrl(.currenciesList, parameters: [:]) { (xmlOpt, _) in
			guard let xml = xmlOpt else {
				DispatchQueue.main.async {
					self.delegate?.cbrService(self, didFetch: [])
				}
				return
			}
			var list = xml["Valuta"]["Item"].compactMap { (item) -> CBRCurrency? in
				guard
					let id = item.attributes["ID"]?.trimmingCharacters(in: .whitespaces),
					let isoCode = item["ISO_Char_Code"].text?.trimmingCharacters(in: .whitespaces),
					let name = item["Name"].text?.trimmingCharacters(in: .whitespaces)
					else {
						return nil
				}

				return CBRCurrency(id: id,
								   isoCode: isoCode,
								   name: name,
								   engName: item["EngName"].text?.trimmingCharacters(in: .whitespaces),
								   nominal: item["Nominal"].text?.trimmingCharacters(in: .whitespaces),
								   parentCode: item["ParentCode"].text?.trimmingCharacters(in: .whitespaces))
			}
			list.append(CBRService.rubCurrency)
			list.sort(by: { $0.isoCode < $1.isoCode })
			DispatchQueue.main.async {
				self.delegate?.cbrService(self, didFetch: list)
			}
		}
	}

	///
	/// Запрашиваем последний известный курс валюты за все десять дней до необходимой даты.
	///
	///	Смотрим курс за последние десять дней до выбранной даты, так как API cbr.ru
	///	не отдает курс за день, если он такой же, как был вчера.
	///	Если за десять дней до выбранной даты не будет ни одной записи о курсе валюты,
	///	будем считать, что все плохо и показывать ошибку.
	///
	/// - Parameters:
	///   - currency: Валюта для получения ее стоимости в рублях
	///   - date: Дата курса валюты
	func fetchCurrencyValue(_ currency: CBRCurrency, date: Date) -> URLSessionDataTask? {
		if currency == CBRService.rubCurrency {
			self.delegate?.cbrService(self, didFetch: 1, for: currency, date: date, error: nil)
			return nil
		}

		let tenDaysBefore = Calendar.current.date(byAdding: .day, value: -10, to: date) ?? date

		let firstDate = self.dateFormatter.string(from: tenDaysBefore)
		let secondDate = self.dateFormatter.string(from: date)

		if let cachedValue = self.cache[self.cacheKey(currency, date)] {
			self.delegate?.cbrService(self, didFetch: cachedValue, for: currency, date: date, error: nil)
			return nil
		}

		return self.xmlFromUrl(.currencyValue, parameters: [
			"date_req1": firstDate,
			"date_req2": secondDate,
			"VAL_NM_RQ": currency.id
		]) { (xmlOpt, error) in
			guard
				let xml = xmlOpt,
				let value = xml["ValCurs"]["Record"].last["Value"].text,
				let nominal = xml["ValCurs"]["Record"].last["Nominal"].text,
				let decimalValue = Decimal(string: value, locale: Locale(identifier: "ru_RU")),
				let decimalNominal = Decimal(string: nominal, locale: Locale(identifier: "ru_RU")),
				decimalNominal > 0
				else {
					DispatchQueue.main.async {
						self.delegate?.cbrService(self,
												  didFetch: 0,
												  for: currency,
												  date: date,
												  error: xmlOpt != nil ? .conversionRateUnavailable : .requestError)
					}
					return
			}
			let result = decimalValue / decimalNominal
			self.cache[self.cacheKey(currency, date)] = result
			DispatchQueue.main.async {
				self.delegate?.cbrService(self,
										  didFetch: result,
										  for: currency,
										  date: date,
										  error: nil)
			}
		}
	}
}
