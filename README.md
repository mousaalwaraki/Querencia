# Querencia-CloudKit
 
 ## Screenshots

<img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/1.png" width="200"> <img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/2.png" width="200"> <img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/3.png" width="200"> <img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/4.png" width="200">  
<img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/5.png" width="200"> <img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/6.png" width="200"> <img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/7.png" width="200"> <img src="https://github.com/mousaalwaraki/Querencia-CloudKit/blob/main/Screenshots/8.png" width="200">  

## Summary

Querencia is designed to make habit tracking and journaling as simple as possible, to encourage a sustainable habit. Rate your day, and add the activities you performed in your day to simplify your journaling and be able to see how different activities impact your day! With multiple journals to use depending on needs, you can reflect more on your day if you feel the need to!   

Journal and Mood tracking app written completely in CoreData and CloudKit.  
Tag activites done in the day with the day mood, with optional extra reflection on the day. Different journals to reflect on the day depending on the requirement. Journals can be edited or removed/added by the user.
Analytics page for user to analyse moods and activities. User can analyse activities depending on mood, to see most recurring activities depending on mood. Alternatively, the user can analyse most recurring moods depending on the users activities. Lastly user can go through a calendar to look at their history and journals of all days.
Journal prompts are provided in the inspiration  to help inspire users to make the prompts their own (or just add it as is), as that was one of the difficulties that users were facing.  
Added a resources page that include videos, blogposts and book recommendations to keep users motivated and using the app.  
Biometric/Passcode lock added to improve security features.   
Daily notification reminders to journal at time of users choice.   
Calendar to review journal entries, with journaled dates highlighted so users can see what days they should review. Date picker to help navigate dates quicker.   

## Challenges

I had created journal using firebase as a backend, however I always had reservations on using firebase. My main concern was security but performance was also a big concern.  
For that reason I wanted to rewrite it using only CoreData. With minimial prior experience in CoreData this was very challenging. However after successfully  rewriting it, I realised that I also needed to create a Public Database for the resources page. This was initially challenging as I had never worked with CloudKit and finding support on it online was more difficult than finding support for CoreData. Once I grasped the basics though, it became very easy to power through it and it became quite simple to create and use CloudKit including CloudKit dashboard.   
Using iOS Charts to display info was difficult as there was no clear documentation for it, but using the sample project and through online forums I was able to create a chart that fit the design and theme of the app.    
Keeping a minimalistic UI throughout app was challenging, but needed to ensure journalling is made as simple as possible.   
Syncing question prompts on all pages including the journalling page (where users write their answers).    
Removing prompts from inspiration after user adds them.    
Biometric/passcode integration was new, however was much easier than expected.   
To not send notifications if user already journaled was relatively difficult especially that the database is set up to create an empty document in the database when user opens app.     

## Appstore link and description

Appstore link: https://apps.apple.com/us/app/querencia/id1512500064#?platform=iphone

Querencia is the area in the arena taken by the bull to draw it's power and be at ease in a fight. It's the place where the bull feels safest and most at home.

I believe that your journal is equivilant to that. It's a safe environment where you reflect on yourself, feel safe from judgement, be yourself completely and unapologetically! After all this journal is made by you, for you. So don't hold back, be yourself, reflect and learn!

Querencia is designed to make habit tracking and journaling as simple as possible, to encourage a sustainable habit. Rate your day, and add the activities you performed in your day to simplify your journaling and be able to see how different activities impact your day! With multiple journals to use depending on needs, you can reflect more on your day if you feel the need to!

Journaling is an ancient tradition that dates to at least the 10th century! Journaling has many documented benefits, by many different individuals and cultures all around the world. These benefits including reducing intrusion, improving working memory, clarifying your thoughts and feelings and many more!

So give it a shot and see the improvements yourself!
