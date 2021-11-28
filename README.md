Intervalometer
==============
I generated a skeleton app and then tweaked it until it would take pictures.

Use [clickable][1] to build the app and load it onto a phone.

Then, in the app, push the button to start taking a picture every fifteen
minutes.

The pictures are saved to `/home/phablet/Pictures/intervalometer.dgoffredo/`.

It stops taking pictures if the phone locks.  Even if you prevent the app from
suspending, the `Camera` library still becomes unavailable on lock.  So, you
have to keep the phone active.  To turn the screen off, I use an external
script (not included in this repository).

The important source file is [Main.qml](qml/Main.qml).

[1]: https://clickable-ut.dev/

