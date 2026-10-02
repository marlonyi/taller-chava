#!/bin/bash
set -e

echo "=== 1. Instalando Flutter SDK (versión stable)... ==="
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 flutter
fi

export PATH="$PATH:$(pwd)/flutter/bin"
flutter --version

echo "=== 2. Compilando aplicacion Flutter Web release... ==="
cd graficos_app
flutter pub get
flutter build web --release

echo "=== 3. Compilacion exitosa terminada ==="
