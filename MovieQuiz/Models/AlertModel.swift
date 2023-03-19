//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anka on 13.03.2023.
//

import UIKit

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    let completion: () -> ()
}
