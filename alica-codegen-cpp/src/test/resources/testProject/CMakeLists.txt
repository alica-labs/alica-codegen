cmake_minimum_required(VERSION 3.17)

project(alicacodegen)

file(GLOB_RECURSE PROJECT_SOURCES *.cpp)
add_library(${PROJECT_NAME} ${PROJECT_SOURCES})

target_include_directories( ${PROJECT_NAME}
        PUBLIC ${PROJECT_SOURCE_DIR}/include/gen/behaviours
        PUBLIC ${PROJECT_SOURCE_DIR}/include/gen/conditions
        PUBLIC ${PROJECT_SOURCE_DIR}/include/gen/constraints
        PUBLIC ${PROJECT_SOURCE_DIR}/include/gen/creators
        PUBLIC ${PROJECT_SOURCE_DIR}/include/gen/domain
        PUBLIC ${PROJECT_SOURCE_DIR}/include/gen/utilityfunctions

        PUBLIC ${PROJECT_SOURCE_DIR}/include/impl/behaviours
        PUBLIC ${PROJECT_SOURCE_DIR}/include/impl/conditions
        PUBLIC ${PROJECT_SOURCE_DIR}/include/impl/constraints
        PUBLIC ${PROJECT_SOURCE_DIR}/include/impl/creators
        PUBLIC ${PROJECT_SOURCE_DIR}/include/impl/domain
        PUBLIC ${PROJECT_SOURCE_DIR}/include/impl/utilityfunctions

        PUBLIC ${PROJECT_SOURCE_DIR}/engine
)
