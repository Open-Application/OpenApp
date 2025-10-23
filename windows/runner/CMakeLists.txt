cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "flutter_bridge.cpp"
  "vpn_service.cpp"
  "elevation_utils.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

apply_standard_settings(${BINARY_NAME})

target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Link against librcc.dll (MinGW-built DLL, MSVC linker needs .lib)
set(LIBRCC_DLL "${CMAKE_SOURCE_DIR}/librcc.dll")
set(LIBRCC_LIB "${CMAKE_SOURCE_DIR}/librcc.lib")

if(NOT EXISTS "${LIBRCC_DLL}")
  message(FATAL_ERROR "librcc.dll not found at ${LIBRCC_DLL}. Please build the DLL from core/export and copy it here.")
endif()

if(NOT EXISTS "${LIBRCC_LIB}")
  message(FATAL_ERROR "librcc.lib not found at ${LIBRCC_LIB}. Please generate it using lib.exe before building.")
endif()

target_link_libraries(${BINARY_NAME} PRIVATE "${LIBRCC_LIB}")
message(STATUS "Linking against librcc.lib (import library for ${LIBRCC_DLL})")

add_dependencies(${BINARY_NAME} flutter_assemble)
