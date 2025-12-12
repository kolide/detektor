### Capturing via the test app

The test app can be used to capture data to add to the test data in `spec/header_capture.yml`

The code for the capture is in `capture_controller.rb` and is reachable at the path `/client_hints/capture`.

#### SSL capture mode

Many clients will not reply with the client hints headers unless it is a secure context.

If you run the rake task `dev:host_capture` or the command

```CHCAPTURE=true ./spec/rails_test_app/bin/rails server```

the test app will use the `localhost` gem to host ssl binding at port `9292`.

To access on your local network, the path will be `https://{your_ip}:9292/client_hints/capture`

#### Android webview capture

There is a rake task for capturing via the Android app in the `extras` dir. If you are familar with Android development and `adb` commands, you can simply host the capture server locally and enter the url in the app once installed.

!! I would highly recommend you uninstall the app as soon as you are done with capture!
The script will do this for you (as long as nothing fails...), but by definition it is an insecure web browser app.

To use the rake task (`dev:android_capture`), you must have `adb` on your path and a device connected. This can be a emulator or real device, but it must appear in the list of `adb devices`.

The task goes like so:
1. The server is started in the background in capture mode
1. The android app is installed on the device
1. The task will send a command to the device to open the app, including its best guess at the url as data
1. !!!! USER ACTION HERE !!! 
    1. you need to check the device and approve the connection when the ssl error occurs (because you are on a localhost cert!)
    1. if the page renders a bunch of data, you did it!
    1. Return to the script and press enter.
1. The task will stop the server.
1. The task will read the test server log and print out (hopefully) the capture data.
1. The task will uninstall the app
1. If everything looks right in the capture data, copy the YAML section into the `spec/header_capture.yml` file. Make sure to replace the name with something helpful