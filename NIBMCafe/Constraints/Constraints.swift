//
//  Constraints.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-26.
//

import Foundation

struct StoryBoardSegues {
    static let launchToHomeSegue = "launchToHomeSegue"
    static let signUptoHomeSegue = "signUptoHomeSegue"
    static let homeToViewDetails = "homeToViewDetails"
}

//Name of the SessionVariables
struct UserSession {
    static let USER_SESSION = "USER_SESSION"
    static let IS_LOGGED_IN = "AUTH_STATE"
}

//List of error captions and messages
struct FieldErrorCaptions {
    static let noConnectionTitle = "No connection"
    static let noConnectionMessage = "The app requires a working internet connection please check your connection settings."
}

struct AppConfig {
    static let connectionCheckTimeout: Double = 10
    static let passwordMinLength = 6
    static let passwordMaxLength = 20
    static let defaultPasswordPlaceholder = "****"
}
