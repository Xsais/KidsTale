/*
 
 Heon Lee
 991280638
 
 A view controller to list available chat rooms
 2020-04-19
 */

import UIKit

class ChatListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var username: String = ""
    var rooms: Array<Room> = [Room]()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Create sample rooms
        let adminRoom: Room = Room.init()
        adminRoom.initWithData(theName: "Administrator Chat", theAvailability: "Available", theImage: "nightsky_unsplash.jpeg")
        let chat1: Room = Room.init()
        chat1.initWithData(theName: "General Chat", theAvailability: "Available", theImage: "above_the_clouds_the_sky-wide.jpg")

        let chat2: Room = Room.init()
        chat2.initWithData(theName: "Discussion Chat", theAvailability: "Available", theImage: "Daniele-Bianchin-above-the-sky.png")

        rooms.append(adminRoom)
        rooms.append(chat1)
        rooms.append(chat2)


    }

    @IBAction func guide(sender: Any) {
        let alert = UIAlertController(title: "Welcome to KidsTale Chat!", message: "1. Click the chat name to enter the chat" +
                "\n2. Swipe from the right to see the information of each chat", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserViewCell ?? UserViewCell(style: .default, reuseIdentifier: "cell")

        tableCell.primaryLabel.text = rooms[indexPath.row].name!

        tableCell.secondaryLabel.text = rooms[indexPath.row].availability!

        //Image for the room
        let img = UIImage(named: rooms[indexPath.row].image!)

        tableCell.myImageView.image = img

        tableCell.accessoryType = .disclosureIndicator

        return tableCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //Programmatically redirect to ChatViewController
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "ChatView") as! ChatViewController

        //Pass the username
        vc.username = self.username
        vc.chatName = rooms[indexPath.row].name!

        self.present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let notification = UITableViewRowAction(style: .normal, title: "What is this chat?") {
            (action, index) in

            var title: String = ""
            var alertMessage: String = ""

            if (self.rooms[indexPath.row].name! == "Discussion Chat") {
                title = "Discussion Chat"
                alertMessage = "You can discuss about stores"
                        + "or books in this chat!"
            } else if (self.rooms[indexPath.row].name! == "Administrator Chat") {

                title = "Administrator Chat"
                alertMessage = "Please ask administrators about any " +
                        "questions regarding the app!"
            } else {

                title = "General Chat"
                alertMessage = "Chat with other KidsTale users!"
            }

            let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        notification.backgroundColor = UIColor(hex: "#3498db")

        return [notification]
    }

}
