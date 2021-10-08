//
//  ErrorHandler.swift
//  converter-money
//
//  Created by Brunno Andrade on 04/10/20.
//

import Foundation

enum ErrorNetwork: String, Error {
    case decodingError = "Erro Decoding"
    case urlError = "URL inválido"
    case connectionError = "Erro de conexão"
    case failure = "Erro desconhecido"
}


enum ValidationError: Error {
    case emptyQuoteOrigin
    case emptyQuoteDestiny
    case zeroValue
    case invalidValue
    case converterError
    case equalsCodes
}


extension ValidationError: LocalizedError {
    var errorDescription: String? {
        
        switch self {
        case .emptyQuoteOrigin:
            return NSLocalizedString(
                "Escolha uma origem para continuar.",
                comment: "")
        case .emptyQuoteDestiny:
            return NSLocalizedString(
                "Escolha um destino para continuar.",
                comment: "")
        case .zeroValue:
            return NSLocalizedString(
                "Digite um valor maior que 0 para continuar.",
                comment: "")
        case .invalidValue:
            return NSLocalizedString(
                "Digite um valor válido para continuar.",
                comment: "")
        case .converterError:
            return NSLocalizedString(
                "Não foi possivel fazern a conversão dos valores.",
                comment: "")
        case .equalsCodes:
            return NSLocalizedString(
                "Selecione moedas diferentes para fazer a conversão.",
                comment: "")
        }
    }
}
