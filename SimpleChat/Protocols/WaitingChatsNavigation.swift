//
//  WaitingChatsNavigation.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 26.05.2021.
//

import UIKit

protocol WaitingChatsNavigation: class{
    func removeWaitingChat(chat: ChatModel)
    
    func changeToCurrent(chat: ChatModel)
    
}
