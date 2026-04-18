# Empty CMakeLists.txt file to satisfy the build system
# This is a minimal CMake configuration that doesn't actually build anything
cmake_minimum_required(VERSION 3.4.1)
project(flutter_empty_native)

# Add a dummy library target that doesn't actually build anything
add_library(flutter_empty SHARED IMPORTED)
