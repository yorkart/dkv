cmake_minimum_required(VERSION 3.20)
project(dkv)

set(CMAKE_CXX_STANDARD 11)
#SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
#SET(THIRD_PARTY_PATH ${CMAKE_CURRENT_BINARY_DIR}/third-party)

option(GRPC_AS_SUBMODULE "submodule" ON)
include(cmake/common.cmake)

# Proto output dir
set(PB_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/generator)
file(MAKE_DIRECTORY ${PB_OUTPUT})

# Proto file
get_filename_component(hw_proto      "./proto/helloworld.proto" ABSOLUTE)
get_filename_component(hw_proto_path "${hw_proto}"              PATH)

# Generated sources
set(hw_proto_srcs "${PB_OUTPUT}/helloworld.pb.cc")
set(hw_proto_hdrs "${PB_OUTPUT}/helloworld.pb.h")
set(hw_grpc_srcs  "${PB_OUTPUT}/helloworld.grpc.pb.cc")
set(hw_grpc_hdrs  "${PB_OUTPUT}/helloworld.grpc.pb.h")

add_custom_command(
        OUTPUT "${hw_proto_srcs}" "${hw_proto_hdrs}" "${hw_grpc_srcs}" "${hw_grpc_hdrs}"
        COMMAND ${_PROTOBUF_PROTOC}
        ARGS --grpc_out "${PB_OUTPUT}"
        --cpp_out "${PB_OUTPUT}"
        -I "${hw_proto_path}"
        --plugin=protoc-gen-grpc="${_GRPC_CPP_PLUGIN_EXECUTABLE}"
        "${hw_proto}"
        DEPENDS "${hw_proto}")

# Include generated *.pb.h files
include_directories("${PB_OUTPUT}")

# hw_grpc_proto
add_library(hw_grpc_proto
        ${hw_grpc_srcs}
        ${hw_grpc_hdrs}
        ${hw_proto_srcs}
        ${hw_proto_hdrs})

target_link_libraries(hw_grpc_proto
        ${_REFLECTION}
        ${_GRPC_GRPCPP}
        ${_PROTOBUF_LIBPROTOBUF})

add_executable(dkv main.cpp)

target_link_libraries(dkv
        hw_grpc_proto
        ${_REFLECTION}
        ${_GRPC_GRPCPP}
        ${_PROTOBUF_LIBPROTOBUF})