//
//  DatabaseManager.swift
//  MessengerAppIOS
//
//  Created by administrator on 09/01/2022.
//

//import Foundation
//import FirebaseDatabase
//// singleton creation below
//// final - cannot be subclassed
//
//
//
//final class DatabaseManager {
//
//    /// Shared instance of class
//    public static let shared = DatabaseManager()
//
//    private let database = Database.database().reference()
//
//    static func safeEmail(emailAddress: String) -> String {
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//    }
//}
//
////final class DatabaseManger {
////
////    static let shared = DatabaseManger()
////
////    // reference the database below
////
////    private let database = Database.database().reference()
////
////    // create a simple write function
////
////
////
////    public func test() {
////        // NoSQL - JSON (keys and objects)
////        // child refers to a key that we want to write data to
////        // in JSON, we can point it to anything that JSON supports - String, another object
////        // for users, we might want a key that is the user's email address
////
////        database.child("foo").setValue(["something":true])
////    }
////}
//// MARK: - account management
//extension DatabaseManger {
//
//    // have a completion handler because the function to get data out of the database is asynchrounous so we need a completion block
//
////
////    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
////        // will return true if the user email does not exist
////
////        // firebase allows you to observe value changes on any entry in your NoSQL database by specifying the child you want to observe for, and what type of observation you want
////        // let's observe a single event (query the database once)
////
////        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
////        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
////
////        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
////            // snapshot has a value property that can be optional if it doesn't exist
////
////            guard snapshot.value as? String != nil else {
////                // otherwise... let's create the account
////                completion(false)
////                return
////            }
//
////            // if we are able to do this, that means the email exists already!
////
////            completion(true) // the caller knows the email exists already
////        }
////    }
////
//    /// Insert new user to database
//    public func insertUser(with user: ChatAppUser){
//
//        database.child(user.safeEmail).setValue(["first_name":user.firstName,"last_name":user.lastName]
//        )
//    }
//}
//struct ChatAppUser {
//    let firstName: String
//    let lastName: String
//    let emailAddress: String
//    //let profilePictureUrl: String
//
//    // create a computed property safe email
//
//    var safeEmail: String {
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//    }
//}
//
//extension DatabaseManger {
//
//
//    // have a completion handler because the function to get data out of the database is asynchrounous so we need a completion block
//
//    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
//        // will return true if the user email does not exist
//
//        // firebase allows you to observe value changes on any entry in your NoSQL database by specifying the child you want to observe for, and what type of observation you want
//        // let's observe a single event (query the database once)
//
//        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//
//        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
//            // snapshot has a value property that can be optional if it doesn't exist
//
//            guard snapshot.value as? String != nil else {
//                // otherwise... let's create the account
//                completion(false)
//                return
//            }
//
//            // if we are able to do this, that means the email exists already!
//
//            completion(true) // the caller knows the email exists already
//        }
//    }
//
//    /// Insert new user to database
//    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void){
//        // adding completion block here so once it's done writing to database, we want to upload the image
//
//        // once user object is creatd, also append it to the user's collection
//        database.child(user.safeEmail).setValue(["first_name":user.firstName,"last_name":user.lastName]) { error, _ in
//            guard error  == nil else {
//                print("failed to write to database")
//                completion(false)
//                return
//            }
//
//            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
//                // snapshot is not the value itself
//                if var usersCollection = snapshot.value as? [[String: String]] {
//                    // if var so we can make it mutable so we can append more contents into the array, and update it
//                    // append to user dictionary
//                    let newElement = [
//                        "name": user.firstName + " " + user.lastName,
//                        "email": user.safeEmail
//                    ]
//                    usersCollection.append(newElement)
//
//                    self.database.child("users").setValue(usersCollection) { error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//                        completion(true)
//                    }
//
//                }else{
//                    // create that array
//                    let newCollection: [[String: String]] = [
//                        [
//                            "name": user.firstName + " " + user.lastName,
//                            "email": user.safeEmail
//                        ]
//                    ]
//                    self.database.child("users").setValue(newCollection) { error, _ in
//                        guard error == nil else {
//                            completion(false)
//                            return
//                        }
//                        completion(true)
//                    }
//                }
//            }
//        }
//    }
//
//    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
//        database.child("users").observeSingleEvent(of: .value) { snapshot in
//            guard let value = snapshot.value as? [[String: String]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//            completion(.success(value))
//
//        }
//    }
//
//    public enum DatabaseError: Error {
//        case failedToFetch
//    }
//}
//// above
//// when user tries to start a convo, we can pull all these users with one request
///*
// users => [
// [
// "name":
// "safe_email":
// ],
// [
// "name":
// "safe_email":
// ],
// ]
// */
//// try to get a reference to an existing user's array
//// if doesn't exist, create it, if it does, append to it
//
//// MARK: - Sending Messages / conversations
//extension DatabaseManger {
//
//    /*  "conversation_id" {
//     "messages": [
//     {
//     "id": String,
//     "type": text, photo, video
//     "content": String,
//     "date": Date(),
//     "sender_email": String,
//     "isRead": true/false,
//     }
//     ]
//     }
//
//
//     conversation => [
//     [
//     "conversation_id":
//     "other_user_email":
//     "latest_message": => {
//     "date": Date()
//     "latest_message": "message"
//     "is_read": true/false
//     }
//
//     ],
//
//     ]
//
//     */
//
//    /// creates a new conversation with target user email and first message sent
//    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//        // put conversation in the user's conversation collection, and then 2. once we create that new entry, create the root convo with all the messages in it
//        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
//              let currentName = UserDefaults.standard.value(forKey: "name") as? String
//              else {
//            return
//        }
//
//        let safeEmail = DatabaseManger.safeEmail(emailAddress: currentEmail) // cant have certain characters as keys
//
//        // find the conversation collection for the given user (might not exist if user doesn't have any convos yet)
//
//        let ref = database.child("\(safeEmail)")
//        // use a ref so we can write to this as well
//
//        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
//            // what we care about is the conversation for this user
//            guard var userNode = snapshot.value as? [String: Any] else {
//                // we should have a user
//                completion(false)
//                print("user not found")
//                return
//            }
//
//            let messageDate = firstMessage.sentDate
//            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
//
//            var message = ""
//
//            switch firstMessage.kind {
//            case .text(let messageText):
//                message = messageText
//            case .attributedText(_):
//                break
//            case .photo(_):
//                break
//            case .video(_):
//                break
//            case .location(_):
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .linkPreview(_):
//                break
//            case .custom(_):
//                break
//            }
//
//            let conversationId = "conversation_\(firstMessage.messageId)"
//
//            let newConversationData: [String:Any] = [
//                "id": conversationId,
//                "other_user_email": otherUserEmail,
//                "name": name,
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false,
//
//                ],
//
//            ]
//
//            //
//            let recipient_newConversationData: [String:Any] = [
//                "id": conversationId,
//                "other_user_email": safeEmail, // us, the sender email
//                "name": currentName,  // self for now, will cache later
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false,
//
//                ],
//
//            ]
//            // update recipient conversation entry
//
//            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { [weak self] snapshot in
//                if var conversations = snapshot.value as? [[String: Any]] {
//                    // append
//                    conversations.append(recipient_newConversationData)
//                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversationId)
//                }else {
//                    // reciepient user doesn't have any conversations, we create them
//                    // create
//                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
//                }
//            }
//
//
//            // update current user conversation entry
//
//            if var conversations = userNode["conversations"] as? [[String: Any]] {
//                // conversation array exits for current user, you should append
//
//                // points to an array of a dictionary with quite a few keys and values
//                // if we have this conversations pointer, we would like to append to it
//
//                conversations.append(newConversationData)
//
//                userNode["conversations"] = conversations // we appended a new one
//
//                ref.setValue(userNode) { [weak self] error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
//                }
//            }else {
//                // create this conversation
//                // conversation array doesn't exist
//
//                userNode["conversations"] = [
//                    newConversationData
//                ]
//
//                ref.setValue(userNode) { [weak self] error, _ in
//                    guard error == nil else {
//                        completion(false)
//                        return
//                    }
//                    self?.finishCreatingConversation(name: name, conversationID: conversationId, firstMessage: firstMessage, completion: completion)
//                }
//
//            }
//
//        }
//
//    }
//
//    private func finishCreatingConversation(name: String, conversationID:String, firstMessage: Message, completion: @escaping (Bool) -> Void){
//        //        {
//        //            "id": String,
//        //            "type": text, photo, video
//        //            "content": String,
//        //            "date": Date(),
//        //            "sender_email": String,
//        //            "isRead": true/false,
//        //        }
//
//
//        let messageDate = firstMessage.sentDate
//        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
//
//        var message = ""
//
//        switch firstMessage.kind {
//        case .text(let messageText):
//            message = messageText
//        case .attributedText(_):
//            break
//        case .photo(_):
//            break
//        case .video(_):
//            break
//        case .location(_):
//            break
//        case .emoji(_):
//            break
//        case .audio(_):
//            break
//        case .contact(_):
//            break
//        case .linkPreview(_):
//            break
//        case .custom(_):
//            break
//        }
//
//        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            completion(false)
//            return
//        }
//
//        let currentUserEmail = DatabaseManger.safeEmail(emailAddress: myEmail)
//
//        let collectionMessage: [String: Any] = [
//            "id": firstMessage.messageId,
//            "type": firstMessage.kind.messageKindString,
//            "content": message,
//            "date": dateString,
//            "sender_email": currentUserEmail,
//            "is_read": false,
//            "name": name,
//        ]
//
//        let value: [String:Any] = [
//            "messages": [
//                collectionMessage
//            ]
//        ]
//
//        print("adding convo: \(conversationID)")
//
//        database.child("\(conversationID)").setValue(value) { error, _ in
//            guard error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//
//    }
//    /// Fetches and returns all conversations for the user with
//
//
//    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
//        database.child("\(email)/conversations").observe(.value) { snapshot in
//            // new conversation created? we get a completion handler called
//            guard let value = snapshot.value as? [[String:Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//            let conversations: [Conversation] = value.compactMap { dictionary in
//                guard let conversationId = dictionary["id"] as? String,
//                      let name = dictionary["name"] as? String,
//                      let otherUserEmail = dictionary["other_user_email"] as? String,
//                      let latestMessage = dictionary["latest_message"] as? [String: Any],
//                      let date = latestMessage["date"] as? String,
//                      let message = latestMessage["message"] as? String,
//                      let isRead = latestMessage["is_read"] as? Bool else {
//                    return nil
//                }
//
//                // create model
//
//                let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
//
//                return Conversation(id: conversationId, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessageObject)
//            }
//
//            completion(.success(conversations))
//
//        }
//    }
//
//
//    /// gets all messages from a given conversation
//    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
//        database.child("\(id)/messages").observe(.value) { snapshot in
//            // new conversation created? we get a completion handler called
//            guard let value = snapshot.value as? [[String:Any]] else {
//                completion(.failure(DatabaseError.failedToFetch))
//                return
//            }
//            let messages: [Message] = value.compactMap { dictionary in
//                guard let name = dictionary["name"] as? String,
//                let isRead = dictionary["is_read"] as? Bool,
//                let messageID = dictionary["id"] as? String,
//                let content = dictionary["content"] as? String,
//                let senderEmail = dictionary["sender_email"] as? String,
//                let type = dictionary["type"] as? String,
//                let dateString = dictionary["date"] as? String,
//                let date = ChatViewController.dateFormatter.date(from: dateString)
//                else {
//                    return nil
//                }
//
//                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
//
//                return Message(sender: sender, messageId: messageID, sentDate: date, kind: .text(content))
//
//            }
//
//            completion(.success(messages))
//
//        }
//    }
//
//    ///// Sends a message with target conversation and message
//    public func sendMessage(to conversation: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
//        // return bool if successful
//
//        // add new message to messages
//        // update sender latest message
//        // update recipient latest message
//
//        self.database.child("\(conversation)/messages").observeSingleEvent(of: .value) { [weak self] snapshot in
//
//            guard let strongSelf = self else {
//                return
//            }
//
//            guard var currentMessages = snapshot.value as? [[String: Any]] else {
//                completion(false)
//                return
//            }
//
//            let messageDate = newMessage.sentDate
//            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
//
//            var message = ""
//
//            switch newMessage.kind {
//            case .text(let messageText):
//                message = messageText
//            case .attributedText(_):
//                break
//            case .photo(_):
//                break
//            case .video(_):
//                break
//            case .location(_):
//                break
//            case .emoji(_):
//                break
//            case .audio(_):
//                break
//            case .contact(_):
//                break
//            case .linkPreview(_):
//                break
//            case .custom(_):
//                break
//            }
//
//            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//                completion(false)
//                return
//            }
//
//            let currentUserEmail = DatabaseManger.safeEmail(emailAddress: myEmail)
//
//            let newMessageEntry: [String: Any] = [
//                "id": newMessage.messageId,
//                "type": newMessage.kind.messageKindString,
//                "content": message,
//                "date": dateString,
//                "sender_email": currentUserEmail,
//                "is_read": false,
//                "name": name,
//            ]
//
//            currentMessages.append(newMessageEntry)
//
//            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
//                guard error == nil else {
//                    completion(false)
//                    return
//                }
//                completion(true)
//
//            }
//
//        }
//
//    }
//
//}
//
import Foundation
import FirebaseDatabase
import MessageKit
import CoreLocation

/// Manager object to read and write data to real time firebase database
final class DatabaseManager {

    /// Shared instance of class
    public static let shared = DatabaseManager()

    private let database = Database.database().reference()

    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManager {

    /// Returns dictionary node at child path
    public func getDataFor(path: String, completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("\(path)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }

}

// MARK: - Account Mgmt

extension DatabaseManager {

    /// Checks if user exists for given email
    /// Parameters
    /// - `email`:              Target email to be checked
    /// - `completion`:   Async closure to return with result
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {

        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? [String: Any] != nil else {
                completion(false)
                return
            }

            completion(true)
        })

    }

    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ], withCompletionBlock: { [weak self] error, _ in

            guard let strongSelf = self else {
                return
            }

            guard error == nil else {
                print("failed ot write to database")
                completion(false)
                return
            }

            strongSelf.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)

                    strongSelf.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
                else {
                    // create that array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]

                    strongSelf.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }

                        completion(true)
                    })
                }
            })
        })
    }

    /// Gets all users from database
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            completion(.success(value))
        })
    }

    public enum DatabaseError: Error {
        case failedToFetch

        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }

    /*
        users => [
           [
               "name":
               "safe_email":
           ],
           [
               "name":
            "safe_email":
           ]
       ]
        */
}

// MARK: - Sending messages / conversations

extension DatabaseManager {

    /*
        "dfsdfdsfds" {
            "messages": [
                {
                    "id": String,
                    "type": text, photo, video,
                    "content": String,
                    "date": Date(),
                    "sender_email": String,
                    "isRead": true/false,
                }
            ]
        }

           conversaiton => [
              [
                  "conversation_id": "dfsdfdsfds"
                  "other_user_email":
                  "latest_message": => {
                    "date": Date()
                    "latest_message": "message"
                    "is_read": true/false
                  }
              ],
            ]
           */

    /// Creates a new conversation with target user emamil and first message sent
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String,
            let currentNamme = UserDefaults.standard.value(forKey: "name") as? String else {
                return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentEmail)

        let ref = database.child("\(safeEmail)")

        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }

            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)

            var message = ""

            switch firstMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
            case .linkPreview(_):
            break
                
            }

            let conversationId = "conversation_\(firstMessage.messageId)"

            let newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]

            let recipient_newConversationData: [String: Any] = [
                "id": conversationId,
                "other_user_email": safeEmail,
                "name": currentNamme,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            // Update recipient conversaiton entry

            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var conversatoins = snapshot.value as? [[String: Any]] {
                    // append
                    conversatoins.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversatoins)
                }
                else {
                    // create
                    self?.database.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                }
            })

            // Update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                // conversation array exists for current user
                // you should append

                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
            }
            else {
                // conversation array does NOT exist
                // create it
                userNode["conversations"] = [
                    newConversationData
                ]

                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }

                    self?.finishCreatingConversation(name: name,
                                                     conversationID: conversationId,
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                })
            }
        })
    }

    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
//        {
//            "id": String,
//            "type": text, photo, video,
//            "content": String,
//            "date": Date(),
//            "sender_email": String,
//            "isRead": true/false,
//        }

        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)

        var message = ""
        switch firstMessage.kind {
        case .text(let messageText):
            message = messageText
//        case .attributedText(_) .photo(_) .video(_) .location(_) .emoji(_) .audio(_) .contact(_).custom(_)
//            break
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        case .linkPreview(_):
        break
        }

        guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }

        let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmmail)

        let collectionMessage: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": message,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": name
        ]

        let value: [String: Any] = [
            "messages": [
                collectionMessage
            ]
        ]

        print("adding convo: \(conversationID)")

        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }

    /// Fetches and returns all conversations for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        database.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                    let name = dictionary["name"] as? String,
                    let otherUserEmail = dictionary["other_user_email"] as? String,
                    let latestMessage = dictionary["latest_message"] as? [String: Any],
                    let date = latestMessage["date"] as? String,
                    let message = latestMessage["message"] as? String,
                    let isRead = latestMessage["is_read"] as? Bool else {
                        return nil
                }

                let latestMmessageObject = LatestMessage(date: date,
                                                         text: message,
                                                         isRead: isRead)
                return Conversation(id: conversationId,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMmessageObject)
            })

            completion(.success(conversations))
        })
    }

    /// Gets all mmessages for a given conversatino
    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else{
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            let messages: [Message] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String,
                    let isRead = dictionary["is_read"] as? Bool,
                    let messageID = dictionary["id"] as? String,
                    let content = dictionary["content"] as? String,
                    let senderEmail = dictionary["sender_email"] as? String,
                    let type = dictionary["type"] as? String,
                    let dateString = dictionary["date"] as? String,
                    let date = ChatViewController.dateFormatter.date(from: dateString)else {
                        return nil
                }
//                var kind: MessageKind?
//                if type == "photo" {
//                    // photo
//                    guard let imageUrl = URL(string: content),
//                    let placeHolder = UIImage(systemName: "plus") else {
//                        return nil
//                    }
//                    let media = Media(url: imageUrl,
//                                      image: nil,
//                                      placeholderImage: placeHolder,
//                                      size: CGSize(width: 300, height: 300))
//                    kind = .photo(media)
//                }
//                else if type == "video" {
//                    // photo
//                    guard let videoUrl = URL(string: content),
//                        let placeHolder = UIImage(named: "video_placeholder") else {
//                            return nil
//                    }
//
//                    let media = Media(url: videoUrl,
//                                      image: nil,
//                                      placeholderImage: placeHolder,
//                                      size: CGSize(width: 300, height: 300))
//                    kind = .video(media)
//                }
//                else if type == "location" {
//                    let locationComponents = content.components(separatedBy: ",")
//                    guard let longitude = Double(locationComponents[0]),
//                        let latitude = Double(locationComponents[1]) else {
//                        return nil
//                    }
//                    print("Rendering location; long=\(longitude) | lat=\(latitude)")
//                    let location = Location(location: CLLocation(latitude: latitude, longitude: longitude),
//                                            size: CGSize(width: 300, height: 300))
//                    kind = .location(location)
//                }
//                else {
//                    kind = .text(content)
//                }
//
//                guard let finalKind = kind else {
//                    return nil
//                }

                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: name)

                return Message(sender: sender,
                               messageId: messageID,
                               sentDate: date,
                               kind: .text(content))
            })

            completion(.success(messages))
        })
    }

    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        // add new message to messages
        // update sender latest message
        // update recipient latest message

        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }

        let currentEmail = DatabaseManager.safeEmail(emailAddress: myEmail)

        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }

            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }

            let messageDate = newMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)

            var message = ""
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                break
            case .video(let mediaItem):
                if let targetUrlString = mediaItem.url?.absoluteString {
                    message = targetUrlString
                }
                break
            case .location(let locationData):
                let location = locationData.location
                message = "\(location.coordinate.longitude),\(location.coordinate.latitude)"
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_):
                break
//            case .linkPreview(_):
//                break
            case .linkPreview(_):
                break
            
            }

            guard let myEmmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }

            let currentUserEmail = DatabaseManager.safeEmail(emailAddress: myEmmail)

            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                "name": name
            ]

            currentMessages.append(newMessageEntry)

            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }

                strongSelf.database.child("\(currentEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                    var databaseEntryConversations = [[String: Any]]()
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": message
                    ]

                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
                        var targetConversation: [String: Any]?
                        var position = 0

                        for conversationDictionary in currentUserConversations {
                            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                targetConversation = conversationDictionary
                                break
                            }
                            position += 1
                        }

                        if var targetConversation = targetConversation {
                            targetConversation["latest_message"] = updatedValue
                            currentUserConversations[position] = targetConversation
                            databaseEntryConversations = currentUserConversations
                        }
                        else {
                            let newConversationData: [String: Any] = [
                                "id": conversation,
                                "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
                                "name": name,
                                "latest_message": updatedValue
                            ]
                            currentUserConversations.append(newConversationData)
                            databaseEntryConversations = currentUserConversations
                        }
                    }
                    else {
                        let newConversationData: [String: Any] = [
                            "id": conversation,
                            "other_user_email": DatabaseManager.safeEmail(emailAddress: otherUserEmail),
                            "name": name,
                            "latest_message": updatedValue
                        ]
                        databaseEntryConversations = [
                            newConversationData
                        ]
                    }

                    strongSelf.database.child("\(currentEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }


                        // Update latest message for recipient user

                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message
                            ]
                            var databaseEntryConversations = [[String: Any]]()

                            guard let currentName = UserDefaults.standard.value(forKey: "name") as? String else {
                                return
                            }

                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
                                var targetConversation: [String: Any]?
                                var position = 0

                                for conversationDictionary in otherUserConversations {
                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                        targetConversation = conversationDictionary
                                        break
                                    }
                                    position += 1
                                }

                                if var targetConversation = targetConversation {
                                    targetConversation["latest_message"] = updatedValue
                                    otherUserConversations[position] = targetConversation
                                    databaseEntryConversations = otherUserConversations
                                }
                                else {
                                    // failed to find in current colleciton
                                    let newConversationData: [String: Any] = [
                                        "id": conversation,
                                        "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
                                        "name": currentName,
                                        "latest_message": updatedValue
                                    ]
                                    otherUserConversations.append(newConversationData)
                                    databaseEntryConversations = otherUserConversations
                                }
                            }
                            else {
                                // current collection does not exist
                                let newConversationData: [String: Any] = [
                                    "id": conversation,
                                    "other_user_email": DatabaseManager.safeEmail(emailAddress: currentEmail),
                                    "name": currentName,
                                    "latest_message": updatedValue
                                ]
                                databaseEntryConversations = [
                                    newConversationData
                                ]
                            }

                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }

                                completion(true)
                            })
                        })
                    })
                })
            }
        })
    }

    public func deleteConversation(conversationId: String, completion: @escaping (Bool) -> Void) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)

        print("Deleting conversation with id: \(conversationId)")

        // Get all conversations for current user
        // delete conversation in collection with target id
        // reset those conversations for the user in database
        let ref = database.child("\(safeEmail)/conversations")
        ref.observeSingleEvent(of: .value) { snapshot in
            if var conversations = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for conversation in conversations {
                    if let id = conversation["id"] as? String,
                        id == conversationId {
                        print("found conversation to delete")
                        break
                    }
                    positionToRemove += 1
                }

                conversations.remove(at: positionToRemove)
                ref.setValue(conversations, withCompletionBlock: { error, _  in
                    guard error == nil else {
                        completion(false)
                        print("faield to write new conversatino array")
                        return
                    }
                    print("deleted conversaiton")
                    completion(true)
                })
            }
        }
    }

    public func conversationExists(iwth targetRecipientEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        let safeRecipientEmail = DatabaseManager.safeEmail(emailAddress: targetRecipientEmail)
        guard let senderEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeSenderEmail = DatabaseManager.safeEmail(emailAddress: senderEmail)

        database.child("\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            // iterate and find conversation with target sender
            if let conversation = collection.first(where: {
                guard let targetSenderEmail = $0["other_user_email"] as? String else {
                    return false
                }
                return safeSenderEmail == targetSenderEmail
            }) {
                // get id
                guard let id = conversation["id"] as? String else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                completion(.success(id))
                return
            }

            completion(.failure(DatabaseError.failedToFetch))
            return
        })
    }

}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String

    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    var profilePictureFileName: String {
        //afraz9-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}

