//
//  SeatSelector.swift
//  BookYourSeat
//
//  Created by Georgekutty on 10/01/19.
//  Copyright © 2019 Georgekutty. All rights reserved.
//

import UIKit

protocol SeatSelectorDelegate {
    func seatSelected(_ seat: Seat)
    func getSelectedSeats(_ seats: NSMutableArray)
}

class SeatSelector: UIScrollView, UIScrollViewDelegate {
    
    var seatSelectorDelegate: SeatSelectorDelegate?
    var seat_width:     CGFloat = 30.0
    var seat_height:    CGFloat = 30.0
    var selected_seats          = NSMutableArray()
    var seat_price:     Float   = 100.0
    var available_image     = UIImage()
    var unavailable_image   = UIImage()
    var disabled_image      = UIImage()
    var selected_image      = UIImage()
    let screen_view       = UIView()
    var selected_seat_limit:Int = 0
    var spcaePerRow:Int = 0
    
    // MARK: - Init and Configuration
    
    func setSeatSize(_ size: CGSize){
        seat_width  = size.width
        seat_height = size.height
    }
    func setSeatMap(_ map: [[String:String]]) {
        
        var initial_seat_x: Int = 0
        var initial_seat_y: Int = 0
        var final_width: Int = 0
        
        for i in 0..<map.count {
            let seat_at_position = map[i]["status"]
            if i % spcaePerRow == 0 && i > 1 {
                if initial_seat_x > final_width {
                    final_width = initial_seat_x
                }
                initial_seat_x = 0
                initial_seat_y += 1
            }
            if seat_at_position == "A" {
                createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: true, isDisabled: false, SeatPrice:map[i]["price"] ?? "0", seatID:map[i]["id"] ?? "0" )
                initial_seat_x += 1
            } else if seat_at_position == "P" {
                createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: true, isDisabled: true, SeatPrice:map[i]["price"] ?? "0", seatID:map[i]["id"] ?? "0")
                initial_seat_x += 1
            } else if seat_at_position == "S" {
                createSeatButtonWithPosition(initial_seat_x, and: initial_seat_y, isAvailable: false, isDisabled: false, SeatPrice:map[i]["price"] ?? "0", seatID:map[i]["id"] ?? "0")
                initial_seat_x += 1
            } else if seat_at_position == "_" {
                initial_seat_x += 1
            }
        }
        
        screen_view.frame = CGRect(x: 0, y: 0, width: CGFloat(final_width) * seat_width, height: CGFloat(initial_seat_y) * seat_height)
        self.contentSize = screen_view.frame.size
        let newContentOffsetX: CGFloat = (self.contentSize.width - self.frame.size.width) / 2
        self.contentOffset = CGPoint(x: newContentOffsetX, y: 0)
        selected_seats = NSMutableArray()
        
        self.delegate = self
        self.addSubview(screen_view)
    }

    
    func createSeatButtonWithPosition(_ initial_seat_x: Int, and initial_seat_y: Int, isAvailable available: Bool, isDisabled disabled: Bool,SeatPrice:String ,seatID:String ) {
        
        let seatButton = Seat(frame: CGRect(
            x: CGFloat(initial_seat_x) * seat_width,
            y: CGFloat(initial_seat_y) * seat_height,
            width: CGFloat(seat_width),
            height: CGFloat(seat_height)))
        if available && disabled {
            self.setSeatAsPopular(seatButton)
        }
        else {
            if available && !disabled {
                self.setSeatAsAvaiable(seatButton)
            }
            else {
                self.setSeatAsUnavaiable(seatButton)
            }
        }
        seatButton.id = seatID
        seatButton.available = available
        seatButton.disabled = disabled
        seatButton.row = initial_seat_y + 1
        seatButton.column = initial_seat_x + 1
        seatButton.price = Float(SeatPrice) ?? 0.0
        seatButton.addTarget(self, action: #selector(SeatSelector.seatSelected(_:)), for: .touchDown)
        screen_view.addSubview(seatButton)
    }
    
    // MARK: - Seat Selector Methods
    
    @objc func seatSelected(_ sender: Seat) {
        if !sender.selected_seat && sender.available {
            if selected_seat_limit != 0 {
                checkSeatLimitWithSeat(sender)
            }
            else {
                self.setSeatAsSelected(sender)
                selected_seats.add(sender)
            }
        }
        else {
            selected_seats.remove(sender)
            if sender.available && sender.disabled {
                self.setSeatAsPopular(sender)
            }
            else {
                if sender.available && !sender.disabled {
                    self.setSeatAsAvaiable(sender)
                }
            }
        }
        
        seatSelectorDelegate?.seatSelected(sender)
        seatSelectorDelegate?.getSelectedSeats(selected_seats)
    }
    func checkSeatLimitWithSeat(_ sender: Seat) {
        if selected_seats.count < selected_seat_limit {
            setSeatAsSelected(sender)
            selected_seats.add(sender)
        }
        else {
            let seat_to_make_avaiable: Seat = selected_seats[0] as! Seat
            if seat_to_make_avaiable.disabled {
                self.setSeatAsPopular(seat_to_make_avaiable)
            }
            else {
                self.setSeatAsAvaiable(seat_to_make_avaiable)
            }
            selected_seats.removeObject(at: 0)
            self.setSeatAsSelected(sender)
            selected_seats.add(sender)
        }
    }
    
    // MARK: - Seat & Availability
    
    func setSeatAsUnavaiable(_ sender: Seat) {
        sender.backgroundColor = UIColor.darkGray
        sender.layer.borderWidth=1.0;
        sender.layer.borderColor=UIColor.white.cgColor
        sender.selected_seat = true
    }
    func setSeatAsAvaiable(_ sender: Seat) {
        sender.backgroundColor = UIColor.purple
        sender.layer.borderWidth=1.0;
        sender.layer.borderColor=UIColor.white.cgColor
        sender.selected_seat = false
    }
    func setSeatAsPopular(_ sender: Seat) {
        sender.backgroundColor = UIColor.magenta
        sender.layer.borderWidth=1.0;
        sender.layer.borderColor=UIColor.white.cgColor
        sender.selected_seat = false
    }
    func setSeatAsSelected(_ sender: Seat) {
        sender.backgroundColor = UIColor.green
        sender.layer.borderWidth=1.0;
        sender.layer.borderColor=UIColor.white.cgColor
        sender.selected_seat = true
    }
    
}


class Seat: UIButton {
    var id:             String     = "0"
    var row:            Int     = 0
    var column:         Int     = 0
    var available:      Bool    = true;
    var disabled:       Bool    = true;
    var selected_seat:  Bool    = true;
    var price:          Float   = 0.0
}

extension String {
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
}

extension UIViewController
{
    // MARK:- Alert
    func dispAlert(alertStr : String , alertTitle : String) {
        let alert = UIAlertController(title: alertTitle, message: alertStr, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            if alertTitle == "success"{
                self.dismiss(animated: false, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
}
    
}

