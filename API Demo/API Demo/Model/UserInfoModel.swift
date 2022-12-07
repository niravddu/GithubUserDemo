/*
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct UserInfoModel : Codable {
    let login : String?
    let id : Int?
    let nodeID : String?
    let avatarURL : String?
    let gravatarID : String?
    let url : String?
    let htmlURL : String?
    let followersURL : String?
    let followingURL : String?
    let gistsURL : String?
    let starredURL : String?
    let subscriptionsURL : String?
    let organizationsURL : String?
    let reposURL : String?
    let eventsURL : String?
    let receivedEventsURL : String?
    let type : String?
    let siteAdmin : Bool?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url = "url"
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try values.decodeIfPresent(String.self, forKey: .login)
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.nodeID = try values.decodeIfPresent(String.self, forKey: .nodeID)
        self.avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
        self.gravatarID = try values.decodeIfPresent(String.self, forKey: .gravatarID)
        self.url = try values.decodeIfPresent(String.self, forKey: .url)
        self.htmlURL = try values.decodeIfPresent(String.self, forKey: .htmlURL)
        self.followersURL = try values.decodeIfPresent(String.self, forKey: .followersURL)
        self.followingURL = try values.decodeIfPresent(String.self, forKey: .followingURL)
        self.gistsURL = try values.decodeIfPresent(String.self, forKey: .gistsURL)
        self.starredURL = try values.decodeIfPresent(String.self, forKey: .starredURL)
        self.subscriptionsURL = try values.decodeIfPresent(String.self, forKey: .subscriptionsURL)
        self.organizationsURL = try values.decodeIfPresent(String.self, forKey: .organizationsURL)
        self.reposURL = try values.decodeIfPresent(String.self, forKey: .reposURL)
        self.eventsURL = try values.decodeIfPresent(String.self, forKey: .eventsURL)
        self.receivedEventsURL = try values.decodeIfPresent(String.self, forKey: .receivedEventsURL)
        self.type = try values.decodeIfPresent(String.self, forKey: .type)
        self.siteAdmin = try values.decodeIfPresent(Bool.self, forKey: .siteAdmin)
    }
    
    init(_ login : String?, id : Int, nodeID : String?, avatarURL : String?, gravatarID : String?, url : String?, htmlURL : String?, followersURL : String?, followingURL : String?, gistsURL : String?, starredURL : String?, subscriptionsURL : String?, organizationsURL : String?, reposURL : String?, eventsURL : String?, receivedEventsURL : String?, type : String?, siteAdmin : Bool) {
        self.login = login
        self.id = id
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.url = url
        self.htmlURL = htmlURL
        self.followersURL = followersURL
        self.followingURL = followingURL
        self.gistsURL = gistsURL
        self.starredURL = starredURL
        self.subscriptionsURL = subscriptionsURL
        self.organizationsURL = organizationsURL
        self.reposURL = reposURL
        self.eventsURL = eventsURL
        self.receivedEventsURL = receivedEventsURL
        self.type = type
        self.siteAdmin = siteAdmin
    }
}
