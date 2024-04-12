# emsdk-docker
WebAssembly compiler emscripten emsdk docker

[English](/README.md)

## Description

- emscripten emsdk をインストールした docker です。ビルドや各種ツールが容易に使えます。
- boost c++ も使える状態になっています。
  - 注意：boost c++ は emscripten には対応していませんが、動作することを期待してヘッダーファイルのみインストールしています。lib を使わないライブラリであれば動く可能性が高そうです。

## docker build
  ```
  > docker build -t emsdk .
  ```

## example

> 補足：Docker for Windows (且つ PowerShell) の場合は "\$(pwd)" を "\${pwd}" に置換すると動作すると思います。

- run emcc & server
  - emcc で cpp ファイルをビルドしているシンプルな例です。
  - サンプルコード sample/main.cpp は boost::math と boost::multiprecision を用いて 100桁(cpp_dec_float_100)の円周率を出力しています。
  ```
  > docker run --rm --name emsdk -v $(pwd)/sample:/opt/vol -w /opt/vol -it emsdk emcc main.cpp -s WASM=1 -o index.html
  ```
  ```
  > docker run --rm --name emsdk -v $(pwd)/sample:/opt/vol -w /opt/vol -p 8080:8080 -it emsdk emrun --no_browser --port 8080 index.html
  ```

- run cmake & server
  - cmake を使ったビルドです。
  - サンプルコード samplecmake/main.cpp は boost::multiprecision を用いてフィボナッチ数列を算出しています。
  ```
  > docker run --rm --name emsdk -v $(pwd)/samplecmake:/opt/vol -w /opt/vol -it emsdk \
    " mkdir -p build \
   && cd build  \
   && emcmake cmake .. \
   && make "
  ```
  ```
  > docker run --rm --name emsdk -v $(pwd)/samplecmake:/opt/vol -w /opt/vol -p 8080:8080 -it emsdk emrun --no_browser --port 8080 index.html
  ```

- use shell
  ```
  > docker run --rm --name emsdk -v $(pwd)/sample:/opt/vol -w /opt/vol -it emsdk /bin/bash
  ```

## Licence
[LICENSE](/LICENSE)

## Contact
- 問題の報告、改善案や御助言など何かありましたら御一報頂けますと幸いです。よろしくお願いします。