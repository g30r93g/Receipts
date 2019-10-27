# Receipts

## Backstory

I was waiting at McDonalds for my order and looked at how long the receipt was and thought,
"Was all that ink and paper really necessary to tell me that my order number is 27 and that I ordered a Fanta?"
Then my friend told me that receipts aren't recyclable due to the paper having plastic in it.
A few weeks later, I find myself at a shop with my friends. I purchased an item and I was asked if I'd like my receipt emailed. I thought "Well it's better than paper" only to find myself not being able to look at the screen and being accustomed to a Mac's keyboard layout, the @ and " symbols got mixed up and the email wasn't sent. Frustrating.

So I decided to do something about this just as a proof of concept.

## How it works

 1. User signs up for account
 2. A unique QR code is generated
 3. When at a supported shop, the user scans their QR code
 4. After the transaction is successful, the receipt contents and payment information are sent to the user's app to be viewed

## How to run this project

In order to run this project, you'll need:
 1. An Apple ID in order to sign certificates
 2. A physical device to run the Receipts Store - Uses the rear camera

Setup your user account first, then the store account.

You'll need to add some products to your store account. Just use items lying around with a barcode or add items manually.
If the item exists in the UPC database, then confirm the match.

Once you've done that, scan a few of those items, perform the checkout and scan your QR code in the User application and you're done!


##

Copyright © George Nick Gorzynski ([g30r93g](https://github.com/g30r93g)) - 2019
