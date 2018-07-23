//
//  Constants.swift
//  Swack
//
//  Created by Mostafa Alaa on 7/22/18.
//  Copyright © 2018 Mostafa Alaa. All rights reserved.
//

import Foundation

typealias  CompletionHandler = (_ Success:Bool)->()

//URL Constants
let BASE_URL = "https://swack.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"

//segues
let LOGIN = "loginSegue"
let CREATE_ACCOUNT = "createAccount"
let UNWIND = "unwindToChannel"

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
