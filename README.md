# emsdk-docker
WebAssembly compiler emscripten emsdk docker

[日本語](/README.ja.md)

## Description

- This is a docker with emscripten emsdk installed. Builds and various tools are easy to use.
- boost c++ is also ready to use.
  - Note: boost c++ does not support emscripten, but I have installed only the header files in hopes that it will work. Libraries that do not use libs would work. maybe.

## docker build
  ```
  > docker build -t emsdk .
  ```

### Environment Variables
  ```
  ARG EMSCRIPTEN_VERSION=3.1.56
  ARG BOOST_VERSION=1.84.0
  ```
  - Example customization
    ```
    > docker build \
      --build-arg EMSCRIPTEN_VERSION=4.0.21 \
      --build-arg BOOST_VERSION=1.89.0 \
      -t emsdk .
    ```


## interactive build (build.sh)
  - `build.sh` lets you pick `EMSCRIPTEN_VERSION` and `BOOST_VERSION` interactively (from a short list of common versions, or type any version yourself), then runs `docker build` for you. Works from WSL on Windows too.
  ```
  > ./build.sh
  ```
  - Any extra arguments are passed straight through to `docker build` (e.g. `./build.sh --no-cache`).

  > **Note (Windows)**
    > - if you're using Docker Desktop for Windows, make sure WSL Integration is enabled for your distro   
    (Docker Desktop → Settings → Resources → WSL Integration) before running `build.sh` from WSL.
    >
    > - if you get `permission denied while trying to connect to the docker API at unix:///var/run/docker.sock`, add your user to the `docker` group (`sudo usermod -aG docker $USER`) and restart your shell (or WSL)  
    or simply run `sudo ./build.sh` instead.

## example

  ```
  > docker run --rm -it emsdk emcc --version
  ```
  ```
  > docker run --rm -it emsdk emsdk list
  ```


> For Docker for Windows (and PowerShell), replace "\$(pwd)" with be "\${pwd}". maybe.

- run emcc & server
  - A simple example of building a cpp file with emcc.
  - Note: use `em++` (not `emcc`) for C++ source files — with some Emscripten versions, `emcc` alone won't link the C++ standard library and you'll get "undefined symbol: std::..." errors.
  - The sample code sample/main.cpp uses boost::math and boost::multiprecision to output 100 digits (cpp_dec_float_100) of pi.
  ```
  > docker run --rm --name emsdk -v $(pwd)/sample:/opt/vol -w /opt/vol -it emsdk em++ main.cpp -s WASM=1 -o index.html
  ```
  ```
  > docker run --rm --name emsdk -v $(pwd)/sample:/opt/vol -w /opt/vol -p 8080:8080 -it emsdk emrun --no_browser --port 8080 index.html
  ```

- run cmake & server
  - Build using cmake.
  - The sample code samplecmake/main.cpp uses boost::multiprecision to calculate the Fibonacci sequence.
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
- If you find any issues or have ideas for improvements, please let me know. Thank you and best regards.
