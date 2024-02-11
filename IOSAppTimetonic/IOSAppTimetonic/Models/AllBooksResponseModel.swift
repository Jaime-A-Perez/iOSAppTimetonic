//
//  AllBooksResponseModel.swift
//  IOSAppTimetonic
//
//  Created by Jaime A. Pérez R. on 7/02/24.
//

import Foundation

/// Represents the main response from an API call.
struct APIResponse: Codable {
    var status: String?
    var timestamp: Int?
    var booksResponse: BooksResponse?
    var createdVersion, requestID: String?

    enum CodingKeys: String, CodingKey {
        case status, timestamp = "sstamp", booksResponse = "allBooks", createdVersion = "createdVNB", requestID = "req"
    }
}

// MARK: - BooksResponse
/// Contains information about books and contacts.
struct BooksResponse: Codable {
    var numberOfBooks, numberOfContacts: Int?
    var contacts: [Contact]
    var books: [Book]
}

// MARK: - Contact
/// Represents a contact within the API response.
struct Contact: Codable {
    var userCode, lastName, firstName: String?
    var timestamp: Int?
    var isConfirmed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userCode = "uC", lastName, firstName, timestamp = "sstamp", isConfirmed
    }
}

// MARK: - Book
/// Defines a book, including details and user preferences.
struct Book: Codable {
    var invited, accepted, archived, showFirstPageOnOpen, deleted: Bool?
    var timestamp, numberOfUnreadMessages, numberOfMembers, bookID, lastMessageRead, lastMedia: Int?
    var bookCode, bookOwner, contactUserCode: String?
    var members: [Member]
    var form: Form?
    var lastMessage: Message?
    var userPreferences: UserPreferences?
    var ownerPreferences: OwnerPreferences?
    var favorite: Bool?
    var order: Int?

    enum CodingKeys: String, CodingKey {
        case invited, accepted, archived
        case showFirstPageOnOpen = "showFPOnOpen"
        case deleted = "del"
        case timestamp = "sstamp"
        case numberOfUnreadMessages = "nbNotRead"
        case numberOfMembers
        case bookID = "sbid"
        case lastMessageRead
        case lastMedia
        case bookCode = "bC"
        case bookOwner = "bO"
        case contactUserCode = "contactUC"
        case members, form = "fpForm", lastMessage = "lastMsg", userPreferences = "userPrefs", ownerPreferences = "ownerPrefs", favorite, order
    }
}

// MARK: - Form
/// Defines a form within a book.
struct Form: Codable {
    var formID: Int?
    var name: String?
    var lastModified: Int?

    enum CodingKeys: String, CodingKey {
        case formID = "sfpid", name, lastModified
    }
}

// MARK: - Message
/// Represents the last message in a book.
struct Message: Codable {
    var messageID: Int?
    var uuid: String?
    var timestamp, lastCommentId: Int?
    var body, bodyHtml, messageType, method, color, text: String?
    var numberOfComments, parentID, numberOfMedias, numberOfEmailCids, numberOfDocuments: Int?
    var bookCode, bookOwner, userCode: String?
    var deleted: Bool?
    var created, lastModified: Int?
    var medias: [Media]?

    enum CodingKeys: String, CodingKey {
        case messageID = "smid"
        case uuid
        case timestamp = "sstamp"
        case lastCommentId
        case body = "msgBody"
        case bodyHtml = "msgBodyHtml"
        case messageType = "msgType"
        case method = "msgMethod"
        case color = "msgColor"
        case text = "msg"
        case numberOfComments
        case parentID = "pid"
        case numberOfMedias
        case numberOfEmailCids
        case numberOfDocuments
        case bookCode = "bC"
        case bookOwner = "bO"
        case userCode = "uC"
        case deleted = "del"
        case created, lastModified, medias
    }
}

// MARK: - Media
/// Represents a media within a message.
struct Media: Codable {
    var id: Int?
    var extensionType, originalName, internalName, uuid: String?
    var size: Int?
    var type, emailCID: String?
    var deleted: Bool?

    enum CodingKeys: String, CodingKey {
        case id, extensionType = "ext", originalName = "originName", internalName = "internName", uuid, size, type, emailCID = "emailCid", deleted = "del"
    }
}

// MARK: - Member
/// Defines a member within a book.
struct Member: Codable {
    var userCode: String?
    var invitationStatus: String?
    var rights: Int?
    
    enum CodingKeys: String, CodingKey {
        case userCode = "uC", invitationStatus = "invite", rights
    }
}

// MARK: - OwnerPreferences & UserPreferences
/// Specific preferences of a book owner.
struct OwnerPreferences: Codable {
    var coverColor: String?
    var useLastImageAsCover: Bool?
    var coverImage, coverType, title: String?
    var allowMemberBroadcast, acceptExternalMessages, notifyMobileConfidentially: Bool?

    enum CodingKeys: String, CodingKey {
        case coverColor = "oCoverColor"
        case useLastImageAsCover = "oCoverUseLastImg"
        case coverImage = "oCoverImg"
        case coverType = "oCoverType"
        case title
        case allowMemberBroadcast = "authorizeMemberBroadcast"
        case acceptExternalMessages = "acceptExternalMsg"
        case notifyMobileConfidentially = "notifyMobileConfidential"
    }
}

/// Specific user preferences within a book.
struct UserPreferences: Codable {
    var maxOfflineMessages: Int?
    var syncWithHubic, decideCoverVarOwner, useLastImageAsCover: Bool?
    var coverColor, coverImage, coverType: String?
    var includedInGlobalSearch, includedInGlobalTasks, notifyByEmailCopy, notifyBySMSCopy, notifyByMobile, notifyWhenMessageInArchivedBook: Bool?
    
    enum CodingKeys: String, CodingKey {
        case maxOfflineMessages = "maxMsgsOffline"
        case syncWithHubic
        case decideCoverVarOwner = "uCovervarOwnerDecide"
        case useLastImageAsCover = "uCoverUseLastImg"
        case coverColor
        case coverImage = "uCoverImg"
        case coverType = "uCoverType"
        case includedInGlobalSearch = "inGlobalSearch"
        case includedInGlobalTasks = "inGlobalTasks"
        case notifyByEmailCopy = "notifyEmailCopy"
        case notifyBySMSCopy = "notifySMSCopy"
        case notifyByMobile
        case notifyWhenMessageInArchivedBook
    }
}
