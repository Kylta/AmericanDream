# American Dream
## Description of the application
### The Baluchon is an application of three pages:

#### 1. Get the exchange rate between the dollar and your current currency.
#### 2. Translate from your favorite language into English
#### 3. Compare the local weather and that of your good old home (just to be happy to be gone ... or not !)

#### To navigate between pages, you will use a tab bar ("tab bar"), each tab corresponding to one of the three pages described above.

## 1. Exchange rate
On the exchange rate page, you can insert an amount in your local currency and see the result in dollars ($). Nothing good sorcery a priori!

To get the exchange rate, you will use the fixer.io API, updated daily. You will need to get the exchange rate at least once a day to be sure to display the correct dollar amount to your users.

## 2. Translation
In the translation page, the user can write the sentence of his choice in French and get his translation in English of course!

For this, you will use the API of Google Translate. Unlike the previous one, this API requires a key that you will obtain following the steps explained in the documentation.

## 3. The weather
In the weather page, you will see weather information for New York and the city of your choice (where you live).

For each city, you will display the current conditions using the OpenWeathermap API, including:

Temperature
Description of conditions (cloudy, sunny), etc...

## Constraints !
- The code is on Github with a consistent commits history.
- The code is clear and readable.
- The code is written in English: comments, variables, functions ...
- The project contains no warning or error.
- You respected the MVC model scrupulously. (or another)
- Your application must contain unit tests that will cover most of the logic of your code.
- The application should display correctly on all iPhone sizes in wearing mode.
- The application must support iOS 11 and higher versions.
