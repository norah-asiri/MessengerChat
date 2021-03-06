//
//  ProfileViewModel.swift
//  MessengerChat
//
//  Created by administrator on 09/01/2022.
//
import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}

