# ShopApp

## Info

A shopping app that has the following functions:

1. User can create account and login via email and password
1. Owners can publish their products and manage their own products
1. User can add products as their favorite
1. User can add products to shopping cart and make purchases
1. User can check their purchase history

## Demo

https://youtu.be/7mcA9c5Deno

## How to use:

- Require API key in auth.dart
- Used custom font: Lato, Anton, and should be in assets/fonts folder

## Tech Highlight:

1. Provider v4
   - for state management
1. FireBase
   - backend database to store data, such as login info, products detail, purchase records
   - handle login autheication
   - handle restriction on views, such as product ownership and purchase records
1. HTTP package
   - to establish connections to Firebase
1. Shared Preference
   - storing login token and expirary time locally
1. Simple Animation
   - For page Transition
