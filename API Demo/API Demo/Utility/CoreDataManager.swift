//
//  CoreDataManager.swift
//  API Demo
//
//  Created by Parth Patel on 24/11/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var objPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserManageCoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core data store failed to initializer, \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    //Get all the notes
    func getAllUsersList() -> [UserListModel] {
        let objFetchRequest: NSFetchRequest<UserListModel> = UserListModel.fetchRequest()
        do {
            return try self.objPersistentContainer.viewContext.fetch(objFetchRequest)
        } catch {
            return []
        }
    }
    
    //Save and update the notes
    func saveUserListData(_ objUserInfoModel: UserInfoModel) {
        let objUserListCDModel: UserListModel!
        let objFetchRequest: NSFetchRequest<UserListModel> = UserListModel.fetchRequest()
        objFetchRequest.predicate = NSPredicate(format: "login = %@", argumentArray: [objUserInfoModel.login ?? ""])
        
        do {
            if let result = try self.objPersistentContainer.viewContext.fetch(objFetchRequest).first {
                objUserListCDModel = result
            } else {
                objUserListCDModel = UserListModel(context: objPersistentContainer.viewContext)
            }
            objUserListCDModel.login = objUserInfoModel.login
            objUserListCDModel.id = Int64(objUserInfoModel.id ?? 0)
            objUserListCDModel.node_id = objUserInfoModel.nodeID
            objUserListCDModel.avatar_url = objUserInfoModel.avatarURL
            objUserListCDModel.gravatar_id = objUserInfoModel.gravatarID
            objUserListCDModel.url = objUserInfoModel.url
            objUserListCDModel.html_url = objUserInfoModel.htmlURL
            objUserListCDModel.followers_url = objUserInfoModel.followersURL
            objUserListCDModel.following_url = objUserInfoModel.followingURL
            objUserListCDModel.gists_url = objUserInfoModel.gistsURL
            objUserListCDModel.starred_url = objUserInfoModel.starredURL
            objUserListCDModel.subscriptions_url = objUserInfoModel.subscriptionsURL
            objUserListCDModel.organizations_url = objUserInfoModel.organizationsURL
            objUserListCDModel.repos_url = objUserInfoModel.reposURL
            objUserListCDModel.events_url = objUserInfoModel.eventsURL
            objUserListCDModel.received_events_url = objUserInfoModel.receivedEventsURL
            objUserListCDModel.type = objUserInfoModel.type
            objUserListCDModel.site_admin = objUserInfoModel.siteAdmin ?? false
            
            do {
                try self.objPersistentContainer.viewContext.save()
                print("User list details saved")
            } catch {
                print("Failed to save user list details \(error)")
            }
        } catch {
            print("Failed to fetch user list details \(error)")
        }
    }
    
    //Get note by user id
    func getNote(_ userID: String) -> Notes? {
        let objFetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let predicate = NSPredicate(format: "userID = %@", argumentArray: [userID])

        objFetchRequest.predicate = predicate
        
        do {
            return try self.objPersistentContainer.viewContext.fetch(objFetchRequest).first ?? nil
        } catch {
            return nil
        }
    }
    
    //Save and update the notes
    func saveNote(_ userID: String, notes: String) -> Bool {
        let objNotesCDModel: Notes!
        let objFetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        objFetchRequest.predicate = NSPredicate(format: "userID = %@", argumentArray: [userID])
        
        do {
            if let result = try self.objPersistentContainer.viewContext.fetch(objFetchRequest).first {
                objNotesCDModel = result
            } else {
                objNotesCDModel = Notes(context: objPersistentContainer.viewContext)
            }
            objNotesCDModel.userID = userID
            objNotesCDModel.notes = notes
            
            do {
                try self.objPersistentContainer.viewContext.save()
                print("Note saved")
                return true
            } catch {
                print("Failed to save notes \(error)")
                return false
            }
        } catch {
            print("Failed to fetch note \(error)")
            return false
        }
    }
}
