include(ExternalProject)

set(PROTOBUF_VERSION v3.9.2)
set(PROTOBUF_TAR_GZ https://github.com/google/protobuf/archive/${PROTOBUF_VERSION}.tar.gz)

ExternalProject_Add(
        protobuf-external
        PREFIX            protobuf
        URL               ${PROTOBUF_TAR_GZ}
#        DOWNLOAD_DIR      ${CMAKE_CURRENT_BINARY_DIR}/protobuf/download
#        SOURCE_DIR        ${CMAKE_CURRENT_BINARY_DIR}/protobuf/src
#        BINARY_DIR        ${CMAKE_CURRENT_BINARY_DIR}/protobuf/bin
        SOURCE_SUBDIR     cmake
        CMAKE_CACHE_ARGS
            "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
            "-Dprotobuf_BUILD_TESTS:BOOL=OFF"
            "-Dprotobuf_BUILD_EXAMPLES:BOOL=OFF"
            "-Dprotobuf_WITH_ZLIB:BOOL=OFF"
            "-DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}"
            "-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/protobuf/install"
        # other project specific parameters
#        BUILD_ALWAYS 1
#        STEP_TARGETS build
#        INSTALL_COMMAND ""
#        CONFIGURE_COMMAND ""
#        BUILD_COMMAND sh autogen.sh && ./configure --prefix=${DMP_CLIENT_SOURCE_DIR}/third/protobuf/build --disable-shared && make -j8
#        INSTALL_COMMAND make install
)

set(PROTOC                ${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/bin/protoc)
set(Protobuf_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/include)
set(Protobuf_BINARY_DIRS  ${CMAKE_CURRENT_BINARY_DIR}/protobuf/install/lib)
#EXternalProject_Get_Property(protobuf-external source_dir)
#include_directories(${source_dir}/src)
#link_directories(${CMAKE_CURRENT_BINARY_DIR}/protobuf)