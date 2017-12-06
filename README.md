# Share PDF

This is a POC to show how to save documents in the app's sandbox directory using a WKWebView and allow upload saved documents to a Nodejs server.

This project is a challenge because of WKWebView is used as intermediary layer that talks to a native feature (Sandbox directory), upload document to a server and display the GUI.

This is the bidirectional communication schema:
![Image](http://www.joshuakehn.com/assets/images/WKWebView.png/highlevel.png)

For further info, read this [article](http://www.joshuakehn.com/2014/10/29/using-javascript-with-wkwebview-in-ios-8.html).
