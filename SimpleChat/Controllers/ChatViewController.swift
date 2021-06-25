//
//  ChatViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 30.05.2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatViewController: MessagesViewController {
    
    private let currentUser: UserModel
    private let currentChat: ChatModel
    
    private var messages: [MessageModel] = []
    
    private var messageListener: ListenerRegistration?
    
    init(currentUser: UserModel, currentChat: ChatModel) {
        self.currentUser = currentUser
        self.currentChat = currentChat
        super.init(nibName: nil, bundle: nil)
        title = currentChat.friendUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.barTintColor = .white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        configureMessageInputBar()

        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToItem(at: IndexPath(row: 0, section: self.messages.count - 1), at: .bottom, animated: false)
           }
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout{
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        messagesCollectionView.backgroundColor = #colorLiteral(red: 0.9098170996, green: 0.9044087529, blue: 0.9139745235, alpha: 1)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageListener = ListenerService.shared.messagesObserve(chat: currentChat, completion: { (result) in
            switch result {
            case .success(var message):
                if let url = message.downloadURL{
                    StorageService.shared.downloadImage(url: url) {[weak self] result in
                        guard let self = self else { return }
                        switch result{
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.showAlert(with: "Error", message: error.localizedDescription)
                        }
                    }
                } else { self.insertNewMessage(message: message) }
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func insertNewMessage(message: MessageModel) {
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()

        let isLatestMessage = messages.firstIndex(of: message) == messages.count - 1
        let shouldScrollToBootom = isLatestMessage && messagesCollectionView.isAtBottom

        messagesCollectionView.reloadData()
        
        if shouldScrollToBootom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func sendImage(image: UIImage) {
        StorageService.shared.uploadImageMessage(image: image, to: currentChat) { result in
            switch result {
            case .success(let url):
                var imageMessage = MessageModel(user: self.currentUser, image: image)
                imageMessage.downloadURL = url
                FirestoreService.shared.sendMessage(chat: self.currentChat, message: imageMessage) { result in
                    switch result{
                    case .success():
                        self.messagesCollectionView.scrollToBottom(animated: true)
                    case .failure(let error):
                        self.showAlert(with: "Error", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func cametaButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            imagePicker.sourceType = .camera
//        }else {
//            imagePicker.sourceType = .photoLibrary
//        }
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}



//MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: currentUser.id, displayName: currentUser.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.item % 4 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                      attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),
                                                   NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        } else { return nil }
        
    }
    
}



//MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (indexPath.item % 4 == 0){
            return 30
        }else { return 0 }
    }
}



//MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.8211756349, green: 0.5609566569, blue: 1, alpha: 1)
    }

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return isFromCurrentSender(message: message) ? .bubbleTail(.bottomRight, .pointedEdge) : .bubbleTail(.bottomLeft, .pointedEdge)
    }
}



//MARK: - configureMessageInputBar

extension ChatViewController {
    
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.textColor = .black
        messageInputBar.inputTextView.keyboardAppearance = UIKeyboardAppearance.light
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.backgroundView.layer.backgroundColor = UIColor.white.cgColor
        messageInputBar.backgroundView.alpha = 1
        messageInputBar.backgroundColor = .white
        messageInputBar.tintColor = .white
        messageInputBar.alpha = 1
        messageInputBar.backgroundView.tintColor = .white
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 0.4033635232)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureCameraIcon()
    }
    
    func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        messageInputBar.sendButton.applyGradients(cornerRadius: 10)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
    
    
    func configureCameraIcon() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = #colorLiteral(red: 0.8211756349, green: 0.5609566569, blue: 1, alpha: 1)
        let cameraImage = UIImage(systemName: "camera")
        cameraItem.image = cameraImage
        
        cameraItem.addTarget(self, action: #selector(cametaButtonTapped), for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
}



//MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = MessageModel(user: currentUser, content: text)
        FirestoreService.shared.sendMessage(chat: currentChat, message: message) { (result) in
            switch result{
            case .success():
                self.messagesCollectionView.scrollToBottom(animated: true)
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
}



//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        sendImage(image: image)
    }
}
