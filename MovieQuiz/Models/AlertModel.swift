//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anka on 13.03.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion: ((UIAlertAction) -> Void)?
}
