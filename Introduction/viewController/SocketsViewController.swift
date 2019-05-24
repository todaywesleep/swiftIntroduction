//
//  SocketsViewController.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/24/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit
import SocketIO

class SocketsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(false), .compress])
    var socket:SocketIOClient? = nil
    var messages:[MessageModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        sendButton.addTarget(self, action: #selector(sendMessageViaSocket), for: .touchUpInside)
        
        setUpSocket()
    }
    
    func setUpSocket() {
        socket = manager.defaultSocket
        
        if let socket = self.socket {
            socket.on(clientEvent: .connect) {data, ack in
                print("socket connected")
            }
            
            socket.on("chat message") { (data, ack) in
                var messageModel:MessageModel? = MessageModel()
                
                if data[0] is Data {
                    messageModel = self.decodeJSON(content: data[0] as! Data)
                    
                    if let message = messageModel {
                        message.author = message.author ?? "Dude"
                        message.message = message.message ?? "Clear"
                        message.id = (message.author! + message.message!).hashValue
                        
                        messageModel = message
                    }
                } else {
                    messageModel!.author = "Dude"
                    messageModel!.message = (data[0] as? String) ?? "Clear"
                    messageModel!.id = (messageModel!.author! + messageModel!.message!).hashValue
                }
                
                self.messages.append(messageModel!)
                self.tableView.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
            }
            
            socket.connect()
        }
    }
    
    func decodeJSON(content: Data) -> MessageModel? {
        do {
            let decoder = JSONDecoder()
            let messageModel = try decoder.decode(MessageModel.self, from: content)
            
            return messageModel
        } catch let error {
            print(error)
            return nil
        }
    }
    
    @objc func sendMessageViaSocket() {
        let messageModel = MessageModel()
        messageModel.author = "Self"
        messageModel.message = messageField.text ?? "Clear"
        messageModel.id = (messageModel.author! + messageModel.message!).hashValue
        
        let encoder = JSONEncoder()
        let messageData = try! encoder.encode(messageModel)
        
        if let socket = self.socket {
            socket.emit("chat message", messageData)
        }
        
        messageField.text = ""
    }
}

extension SocketsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        cell.message = messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
