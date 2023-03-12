//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anka on 13.03.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion = {
        print(AlertModel(title: <#T##String#>, message: <#T##String#>, buttonText: <#T##String#>))
    }
}
