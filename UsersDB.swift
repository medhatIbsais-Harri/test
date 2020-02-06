//
//  UsersDB.swift
//  harriTask
//
//  Created by Medhat Ibsais on 10/14/19.
//  Copyright © 2019 Medhat Ibsais. All rights reserved.
//

import UIKit

class UsersDB {
    
    static func makePostCall(size:Int, start:Int,userCompletionHandler: @escaping ([UserDataFetchBody]?, Error?) -> Void) {
        
//        var allUsers = [User]()
        
        let todosEndpoint: String = Keys.usersURL
      guard let todosURL = URL(string: todosEndpoint) else {
        print("Error: cannot create URL")
        return
      }
      var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
      todosUrlRequest.httpMethod = "POST"
      let newTodo: [String: Any] = ["size": size, "start": start, "locations":["40.7127753","-74.0059728"]]
      let jsonTodo: Data
      do {
        jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
        todosUrlRequest.httpBody = jsonTodo
      } catch {
        print("Error: cannot create JSON from todo")
        return
      }
      let session = URLSession.shared
      let task = session.dataTask(with: todosUrlRequest) {
        (data, response, error) in
        guard error == nil else {
          print("error calling POST on /todos/1")
          print(error!)
          return
        }
        guard let responseData = data else {
          print("Error: did not receive data")
          return
        }
        // parse the result as JSON, since that's what the API provides
        do {
        let dataRecieved = try JSONDecoder().decode(UserSearchDataResponse.self, from: responseData)
            userCompletionHandler(dataRecieved.data.results,nil)
        }
        catch let theError {
            print(theError)
        }
        
        
     /*   do {
          guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                    options: []) as? [String: Any] else {
              print("Could not get JSON from responseData as dictionary")
              return
          }
//            print(receivedTodo)
            let data = receivedTodo[Keys.dataKey] as! [String:Any]
            let results = data[Keys.resultKey] as! [Any]
            
//            do {
//                let user = try JSONDecoder().decode([UserDataFetchBody].self, from: results)
//            }
//            catch {
//
//                print("error decoding")
//            }
            
            for eachUser in results {
                
                let userData = eachUser as! [String:Any]
                
//                do {
//                    let user = try JSONDecoder().decode([UserDataFetchBody].self, from: results as! Data)
//                }
//                catch {
//
//                    print("error decoding")
//                }
                
                var newUser = User()
                
                newUser.firstName = userData[Keys.firstNameKey] as? String
                newUser.lastName = userData[Keys.lastNameKey] as? String
                newUser.isFirstJob = userData[Keys.isFirstJobKey] as? Bool
                newUser.id = userData[Keys.idKey] as? Int
                
                if let position = userData[Keys.positionKey] as? [String:Any]{
                    
                    newUser.position = position
                }
                else if let positions = userData[Keys.positionsKey] as? [[String:Any]] {
                    
                    newUser.positions = positions
                }
                if let profileUUID = userData[Keys.profileImageUUIDKey] as? String {
                    
                    newUser.imageUUID = profileUUID
                    
                    newUser.imageLink = Keys.userImageURL + String(newUser.id!) + Keys.publicImageDirectory + profileUUID + Keys.imageSize
                }

                allUsers.append(newUser)
            }
            
            // returns array of users each time the function used
            userCompletionHandler(allUsers, nil)
            
        } catch  {
          print("error parsing response from POST on /todos")
          return
        }
        */
        
      }
        
      task.resume()
        
    }
    
}
