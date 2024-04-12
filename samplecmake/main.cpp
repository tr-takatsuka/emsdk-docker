#include <stdio.h>
#include <iostream>

#include <emscripten.h>
#include <emscripten/bind.h>

#include <boost/multiprecision/cpp_int.hpp>

emscripten::val testFibonacci(int count)
{
	boost::multiprecision::cpp_int a = 0, b = 1, result = 0;
	for (int i = 0; i < count; i++) {
		result = a + b;
		a = b;
		b = result;
	}
	std::string s = result.str();
	return emscripten::val(s);
}

EMSCRIPTEN_BINDINGS(module) {
	emscripten::function("testFibonacci", &testFibonacci);
}
