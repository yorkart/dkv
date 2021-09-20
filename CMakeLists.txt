cmake_minimum_required(VERSION 3.20)
project(dkv)

set(CMAKE_CXX_STANDARD 11)
#SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
#SET(THIRD_PARTY_PATH ${CMAKE_CURRENT_BINARY_DIR}/third-party)

include(cmake/protobuf.cmake)

#EXternalProject_Get_Property(protobuf-external source_dir)
#include_directories(${source_dir}/src)
#link_directories(${CMAKE_CURRENT_BINARY_DIR}/protobuf)

message(STATUS "Using ${PROTOC}")
message(STATUS "Using ${Protobuf_INCLUDE_DIRS}")
message(STATUS "Using ${Protobuf_BINARY_DIRS}")

###########
# proto lib
###########
include_directories(${Protobuf_INCLUDE_DIRS})
#include_directories(${CMAKE_CURRENT_BINARY_DIR}/protobuf/include)

link_libraries(
#        dkv PROPERTIES IMPORTED_LOCATION
        "${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/lib/libprotobuf-lited.a"
        "${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/lib/libprotobufd.a"
        "${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/lib/libprotocd.a"
)

################
# grpc
################
include(cmake/grpc.cmake)

add_executable(dkv main.cpp ${pb_echo_proto_srcs} ${pb_echo_proto_hdrs})
add_dependencies(dkv protobuf-external)

#add_library(libprotoc IMPORTED STATIC GLOBAL)
#add_library(libprotobuf IMPORTED STATIC GLOBAL)

#target_link_libraries(dkv protobuf)