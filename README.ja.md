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

### 環境変数
  ```
  ARG EMSCRIPTEN_VERSION=3.1.56
  ARG BOOST_VERSION=1.84.0
  ```
  - カスタマイズ例
    ```
    > docker build \
      --build-arg EMSCRIPTEN_VERSION=4.0.21 \
      --build-arg BOOST_VERSION=1.89.0 \
      -t emsdk .
    ```


## 対話式ビルド (build.sh)
  - `build.sh` を使うと `EMSCRIPTEN_VERSION` と `BOOST_VERSION` を対話式に選択できます（よく使うバージョンの候補から選ぶか、任意のバージョンを直接入力）。選択後は自動で `docker build` を実行します。Windows でも WSL から実行できます。
  ```
  > ./build.sh
  ```
  - 追加の引数はそのまま `docker build` に渡されます（例: `./build.sh --no-cache`）。

  > **注意（Windows）**  
    > - Docker Desktop for Windows を使っている場合は、WSL から `build.sh` を実行する前に WSL Integration が有効になっているか確認してください  
    （Docker Desktop → 設定(Settings) → Resources → WSL Integration）。
    >
    > - `permission denied while trying to connect to the docker API at unix:///var/run/docker.sock` というエラーが出た場合は、ユーザーを `docker` グループに追加し（`sudo usermod -aG docker $USER`）、シェル（またはWSL）を再起動してください。  
    もしくは `sudo ./build.sh` のように sudo を付けて実行してください。

## example

  ```
  > docker run --rm -it emsdk emcc --version
  ```
  ```
  > docker run --rm -it emsdk emsdk list
  ```

> 補足：Docker for Windows (且つ PowerShell) の場合は "\$(pwd)" を "\${pwd}" に置換すると動作すると思います。

- run emcc & server
  - emcc で cpp ファイルをビルドしているシンプルな例です。
  - 注意：C++ のソースファイルは `emcc` ではなく `em++` を使ってください。Emscriptenのバージョンによっては `emcc` だけではC++標準ライブラリがリンクされず、"undefined symbol: std::..." エラーになることがあります。
  - サンプルコード sample/main.cpp は boost::math と boost::multiprecision を用いて 100桁(cpp_dec_float_100)の円周率を出力しています。
  ```
  > docker run --rm --name emsdk -v $(pwd)/sample:/opt/vol -w /opt/vol -it emsdk em++ main.cpp -s WASM=1 -o index.html
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