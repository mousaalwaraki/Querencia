//
//  LocalNotification.swift
//  Snappy Wins
//
//  Created by Marwan Elwaraki on 30/03/2020.
//  Copyright © 2020 marwan. All rights reserved.
//

import Foundation

struct LocalNotification {
    var title: String?
    var body: String?
}

var titleArray: [String] = []
var bodyArray: [String] = []
var newTitle: String = "Smth"
var newBody: String = "Smth"

func getTitle() {
    titleArray.append("Reflect on your day")
    titleArray.append("How was your day?")
    titleArray.append("Take a moment to journal!")
    
    newTitle = titleArray.randomElement()!
}

func getBody() {
    bodyArray.append("“There’s simply no better way to learn about your thought processes than to write them down.“ - Barbara Markway")
    bodyArray.append("“Journal writing is a voyage to the interior.“ - Christina Baldwin")
    bodyArray.append("“The habit of writing for my eye is good practice. It loosens the ligaments.“ - Virginia Woolf")
    bodyArray.append("“This pouring thoughts out on paper has relieved me. I feel better and full of confidence and resolution.“ - Diet Eman")
    bodyArray.append("“Journal writing gives us insights into who we are, who we were, and who we can become.“ - Sandra Marinella")
    bodyArray.append("“When I look back on my personal story through my journals, it struck me my words had an unmatched power to heal me. To change me.“ - Sandra Marinella")
    bodyArray.append("“You must remember that your story matters. What you write has the power to save a life, sometimes that life is your own.“ - Stalina Goodwin")
    bodyArray.append("“Journaling can be an excellent way to increase self-awareness, discover and change habits.“ - Akiroq Brost")
    bodyArray.append("“Documenting little details of your everyday life becomes a celebration of who you are.“ - Carolyn V. Hamilton")
    bodyArray.append("“These empty pages are your future, soon to become your past. T will read the most personal tale you shall ever find in a book.“ - Anon")
    bodyArray.append("“He captures memories because if he forgets them, it's as though they didn't happen.“ - Donald Miller")
    bodyArray.append("“Successful journals break the deadlock of introspective obsession.“ - Alexandra Johnson")
    bodyArray.append("“The pages afforded glimpses into my soul where I'd hidden it, behind masks of paper and ink.“ - Rachel Schade")
    bodyArray.append("“I journal my joy, and my joy expands exponentially forevermore. So be it.“ - Amy Mercree")
    bodyArray.append("“Writing is the only way I have to explain my own life to myself.“ - Pat Conroy")
    bodyArray.append("“Journaling is like whispering to one’s self and listening at the same time.“ - Mina Murray")
    bodyArray.append("“People who keep journals have life twice.“ - Jessamyn West")
    bodyArray.append("“Keeping a journal of what’s going on in your life is a good way to help you distill what’s important and what’s not.“ - Martina Navratilova")
    bodyArray.append("“In the journal I do not just express myself more openly than I could to any person; I create myself.“ - Susan Sontag")
    bodyArray.append("“I can shake off everything as I write; my sorrows disappear, my courage is reborn.“ - Anne Frank")
    bodyArray.append("“Journal writing, when it becomes a ritual for transformation, is not only life-changing but life-expanding.“ - Jen Williamson")
    bodyArray.append("“I love my journal as much as I love my phone. I find it to be a big part of my self-care to reflect on my day and write words that inspire me.“ - Franchesca Ramsey")
    bodyArray.append("“Journaling is paying attention to the inside for the purpose of living well from the inside out.“ - Lee Wise")
    bodyArray.append("“A journal is your completely unaltered voice.“ - Lucy Dacus")
    bodyArray.append("“As there are a thousand thoughts lying within a man that he does not know till he takes up the pen to write.“ - William Thackeray")
    bodyArray.append("“When I look back on my personal story through my journals, it struck me my words had an unmatched power to heal me. To change me.“ - Sandra Marinella")
    bodyArray.append("“Journal writing gives us insights into who we are, who we were, and who we can become.“ - Sandra Marinella")
    
    newBody = bodyArray.randomElement()!
}

extension LocalNotificationManager {
    func getRandomNotification() -> LocalNotification? {
//        for _ in 0...4 {
        getTitle()
        getBody()
      return LocalNotification(title: "\(newTitle)", body: "\(newBody)")
//        }
//        potentialNotifications.append(LocalNotification(title: "Reflect on your day", body: "Reflect through your day and take note of what happened."))
//        potentialNotifications.append(LocalNotification(title: "Find a win", body: "Or browse through your existing wins and celebrate them!"))
//        potentialNotifications.append(LocalNotification(title: "Just checking in", body: "It's been a while. I hope you're having a good day."))
//        potentialNotifications.append(LocalNotification(title: "Today is special", body: "It may seem like just another day. But there's a unique win in there somewhere. Find it."))
//        potentialNotifications.append(LocalNotification(title: "Add a win", body: "If you can't think of any then just read through your previous ones. And there you have it, you reflected today. Now that's a win."))
//        potentialNotifications.append(LocalNotification(title: "Smile", body: "Today is beautiful. We just need to find the beauty."))
//        potentialNotifications.append(LocalNotification(title: "Fun fact", body: "In Switzerland, it's illegal to own just one guinea pig. Want another fun fact? Learning new facts is a win. Note it down!"))
//        potentialNotifications.append(LocalNotification(title: "Fun fact", body: "Movie trailers were originally shown after the movie, hence the name 'trailers'."))
//        potentialNotifications.append(LocalNotification(title: nil, body: "Having a good day starts with you. Let's make today great."))
//        potentialNotifications.append(LocalNotification(title: "How's your day?", body: "What defines a good day for you? What moments do you consider wins? Take note of them."))
//        potentialNotifications.append(LocalNotification(title: "What's your smallest win today?", body: "Start there and work your way up. Take note of every win."))
//        potentialNotifications.append(LocalNotification(title: "Increasing your wins", body: "The quickest way to increase your wins is to pay more attention to them. What was your first win today?"))
//        potentialNotifications.append(LocalNotification(title: "Double points day!", body: "Did you know that taking note of a win makes you happier? So by saving a win, you're creating a second new win. Double win!"))
//        return potentialNotifications.randomElement()
        //potentialNotifications.append(LocalNotification(title: <#T##String?#>, body: <#T##String?#>))
    }
}
