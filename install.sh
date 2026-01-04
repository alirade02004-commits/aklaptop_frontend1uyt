#!/bin/bash
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git
fi
flutter/bin/flutter config --enable-web
flutter/bin/flutter doctor
