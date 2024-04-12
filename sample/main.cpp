#include <stdio.h>
#include <iostream>

#include <boost/math/constants/constants.hpp>
#include <boost/multiprecision/cpp_dec_float.hpp>

int main(int argc, char ** argv) {
  auto pi = boost::math::constants::pi<boost::multiprecision::cpp_dec_float_100>();
  std::cout << pi.str() << std::endl;
}

