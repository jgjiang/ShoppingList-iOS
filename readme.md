{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf810
{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;\f1\fnil\fcharset0 Menlo-Bold;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red255\green0\blue0;}
{\*\expandedcolortbl;;\csgenericrgb\c0\c0\c0;\csgenericrgb\c100000\c0\c0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww19320\viewh11720\viewkind0
\deftab543
\pard\tx543\pardeftab543\pardirnatural\partightenfactor0

\f0\fs24 \cf2 \CocoaLigature0 This project aims to provide a demo of a shopping cart. Open 
\f1\b \cf3 \ul \ulc3 ShoppingList.xcworkspace
\f0\b0 \cf2 \ulnone  file to start this application\
\
The function of this app is as follows:\
1. add a product item into the home screen (display in a tableview)\
2. update the product item attributes (image, name, unit price, and quantity)\
3. swipe on an item and click "buy" button, you can transfer items into shopping cart screen (display in a tableview). Note that I don't delete the item of the first screen, because this is the simulation of shopping app.\
4. swipe on an item and click "share" button, you can post information of this item to Facebook\
5. a user can sign up and login to this application\
6. Two statistics including total quantity and the most expensive unit price are displayed \
7. can modify the quantity on shopping cart screen. (increase/decrease)\
\

\f1\b \cf3 Make note:
\f0\b0 \cf2 \
I used Google firebase to implement user login and signup functionality. The user account can be stored in the firebase cloud database. \
\
To test login functionality, you can use \
\
email: 116220368@umail.ucc.ie\
password: 21006329\
\
To test signup functionality, you should use a valid email. After you click signup button, a verify email will be sent to your email. Click that verification URL to complete verification. Finally, you can use the email to log in. If you don't verify the email, you cannot log in.}