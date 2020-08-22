cmake_minimum_required(VERSION 3.13)

project(alicacodegen)

file(GLOB_RECURSE PROJECT_SOURCES *.cpp)
add_library(${PROJECT_NAME} ${PROJECT_SOURCES})

target_include_directories( ${PROJECT_NAME}
        PUBLIC ${PROJECT_SOURCE_DIR}/include/gen/
        PUBLIC ${PROJECT_SOURCE_DIR}/include/impl/
        PUBLIC ${PROJECT_SOURCE_DIR}/engine
)
