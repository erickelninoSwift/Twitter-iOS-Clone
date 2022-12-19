//
//  Constants.swift
//  Twitter  iOS Clone
//
//  Created by Erick El nino on 2022/11/17.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Firebase

let ERICKLNINO_JACKPOT_DB_REF = Database.database().reference()
let ERICKLNINO_JACKPOT_USERS_REF = ERICKLNINO_JACKPOT_DB_REF.child("Users")

let ERICKELNINO_JACKPOT_STORAGE_REF = Storage.storage().reference()
let ERICKELNINO_JACKPOT_STORAGE_PROFILIMAGE = ERICKELNINO_JACKPOT_STORAGE_REF.child("Profile_Images")

let ERICKELNINO_JACKPOT_TWEET_REF = ERICKLNINO_JACKPOT_DB_REF.child("Tweets")
let ERICKELNINO_JACKPOT_USER_TWEET = ERICKLNINO_JACKPOT_DB_REF.child("Users-Tweets")

let ERICKELNINO_JACKPOT_USER_FOLLOWERS = ERICKLNINO_JACKPOT_DB_REF.child("followers")
let ERICKELNINO_JACKPOT_USER_FOLLOWING = ERICKLNINO_JACKPOT_DB_REF.child("following")

let ERICKELNINO_JACKPOT_TWEET_REPLY = ERICKLNINO_JACKPOT_DB_REF.child("Tweets-replies")
