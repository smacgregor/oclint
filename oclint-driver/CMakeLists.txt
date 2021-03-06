CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(OCLINT_DRIVER)

SET(CMAKE_MODULE_PATH
    ${CMAKE_MODULE_PATH}
    "${CMAKE_CURRENT_SOURCE_DIR}/../oclint-core/cmake"
    )

INCLUDE(OCLintConfig)

INCLUDE_DIRECTORIES(
    ${OCLINT_SOURCE_DIR}/include
    )
LINK_DIRECTORIES(
    ${OCLINT_BUILD_DIR}/lib
    )

INCLUDE_DIRECTORIES(${OCLINT_DRIVER_SOURCE_DIR}/include)

ADD_SUBDIRECTORY(lib)

ADD_EXECUTABLE(oclint-${OCLINT_VERSION_RELEASE} main.cpp)
TARGET_LINK_LIBRARIES(oclint-${OCLINT_VERSION_RELEASE}
    OCLintDriver
    OCLintRuleSet
    OCLintCore
    clangStaticAnalyzerFrontend
    clangStaticAnalyzerCheckers
    clangStaticAnalyzerCore
    clangRewriteFrontend
    clangRewriteCore
    ${CLANG_LIBRARIES}
    ${REQ_LLVM_LIBRARIES}
    ${CMAKE_DL_LIBS}
    )
