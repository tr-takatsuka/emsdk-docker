cmake_minimum_required(VERSION 2.8)

set(CMAKE_BUILD_TYPE Debug)

add_executable (main
	"./main.cpp"
)

if (EMSCRIPTEN)
    set(CMAKE_EXECUTABLE_SUFFIX ".html")
    set(CMAKE_CXX_FLAGS "-std=c++20 --bind -s NO_DISABLE_EXCEPTION_CATCHING -s WASM=1")
endif()

