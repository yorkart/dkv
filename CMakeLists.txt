cmake_minimum_required(VERSION 3.20)
project(dkv)

set(CMAKE_CXX_STANDARD 11)
#SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
#SET(THIRD_PARTY_PATH ${CMAKE_CURRENT_BINARY_DIR}/third-party)

include(cmake/protobuf.cmake)

#EXternalProject_Get_Property(protobuf-external source_dir)
#include_directories(${source_dir}/src)
#link_directories(${CMAKE_CURRENT_BINARY_DIR}/protobuf)

#include_directories(${source_dir})

message(STATUS "Using ${PROTOC}")
message(STATUS "Using ${Protobuf_INCLUDE_DIRS}")
message(STATUS "Using ${Protobuf_BINARY_DIRS}")

#############
# generator
#############
# Proto output dir
set(PB_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/generator)
file(MAKE_DIRECTORY ${PB_OUTPUT})

# Proto file
get_filename_component(pb_echo_proto "./proto/pb_echo.proto" ABSOLUTE)
get_filename_component(pb_echo_proto_path "${pb_echo_proto}" PATH)
message(STATUS "pb_echo_proto      ${pb_echo_proto}")
message(STATUS "pb_echo_proto_path ${pb_echo_proto_path}")

# Generated sources
set(pb_echo_proto_srcs "${PB_OUTPUT}/pb_echo.pb.cc")
set(pb_echo_proto_hdrs "${PB_OUTPUT}/pb_echo.pb.h")
message(STATUS "pb_echo_proto_srcs ${pb_echo_proto_srcs}")
message(STATUS "pb_echo_proto_hdrs ${pb_echo_proto_hdrs}")

# generate proto struct
add_custom_command(
        OUTPUT  ${pb_echo_proto_srcs} ${pb_echo_proto_hdrs}
        COMMAND ${PROTOC} --proto_path ${pb_echo_proto_path} --cpp_out=${PB_OUTPUT} ${pb_echo_proto}
        DEPENDS ${pb_echo_proto})

###########
# proto lib
###########
include_directories(${Protobuf_INCLUDE_DIRS})
#include_directories(${CMAKE_CURRENT_BINARY_DIR}/protobuf/include)

#FIND_LIBRARY()

link_libraries(
#        dkv PROPERTIES IMPORTED_LOCATION
        "${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/lib/libprotobuf-lited.a"
        "${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/lib/libprotobufd.a"
        "${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/lib/libprotocd.a"
)

add_executable(dkv main.cpp ${pb_echo_proto_srcs} ${pb_echo_proto_hdrs})

#add_dependencies(dkv protobuf-external)
#add_library(libprotoc IMPORTED STATIC GLOBAL)
#add_library(libprotobuf IMPORTED STATIC GLOBAL)

#target_link_libraries(dkv protobuf)