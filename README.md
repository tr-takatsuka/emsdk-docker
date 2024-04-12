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

## example

> For Docker for Windows (and PowerShell), replace "\$(pwd)" with be "\${pwd}". maybe.

- run emcc & server
  - A simple example of building a cpp file with emcc.
  - The sample code sample/main.cpp uses boost::math and boost::multiprecision to output 100 digits (cpp_dec_float_100) of pi.
  ```
  > docker run --rm --name emsdk -v $(pwd)/sample:/opt/vol -w /opt/vol -it emsdk emcc main.cpp -s WASM=1 -o index.html
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
