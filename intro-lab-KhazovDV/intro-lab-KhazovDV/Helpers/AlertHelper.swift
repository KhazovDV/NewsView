//
//  AlertHelper.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit

enum AlertFactory {
    static func makeEndOfHistoryAlert() -> UIAlertController {
        makeAlert(title: "Конец истории 😢", message: "Новостей больше не найдено")
    }

    static func makeNetworkErrorAlert() -> UIAlertController {
        makeAlert(title: "Ошибка сети 😢", message: "Невозможно загрузить данные")
    }

    private static func makeAlert(title: String, message: String) -> UIAlertController {
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertView.addAction(
            UIAlertAction(title: "Ок", style: .default, handler: nil)
        )
        return alertView
    }
}
