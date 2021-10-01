# Private Audit

This file explains how to very easily audit this app for any security risk to your pc or account.

## Basics
To access/modify data on your pc I know 3 options
 
 -  I could use platform channels to run platform-specific code
 -  I could have harmful code directly in the platform-specific code
 -  I could use plugins to access your data from the flutter code.
 
*As far as I know, there is no option to access your data from the flutter code without using a plugin*
 
Because reviewing the full code takes long and is hard, we are just gonna make our lives easy and audit this app by just looking at the plugins and the platform code.

## Reviewing the plugins

The plugins used are stored in `pubspec.yml` and are:
 -  http: to connect to the blizzard servers
 -  pointycastle: for encryption and hash functions
 -  base32: to send and receive data from blizzards servers, because they use base32 for that
 -  scoped_model: used for changing the region on the main page, when it's changed in the recover-page and vise versa
 -  qr_flutter: for creating a QR-Code to scan in with your smartphone

As you can see I can't access your data via using plugins from flutter code

## Auditing the platform code

To easily verify that I didn't inject harmful code into platform folders:
 -  delete the platform folder
 -  recreate them using flutter (command below)
 -  build the app from there

```bash
cd bma_desktop_setup
flutter create --project-name="bma_desktop_setup" --org="io.github.connectety" --description="helps setting up a totp app to use as a second factor authenticator for blizzard" .
```

(because flutter is continually updated, there are likely changes to the platform folders from the once you deleted.)

## Why this can't give me access to your account.

Theoretically, I could use the http-plugin to send the data to a server I own, but most I could send would be the TOTP token.
To access your account I would still need the username and password, which you didn't enter.
I also can't read the data from your pc, as proven above.
