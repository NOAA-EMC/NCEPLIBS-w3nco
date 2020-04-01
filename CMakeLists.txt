cmake_minimum_required(VERSION 3.15)

file(STRINGS "VERSION" pVersion)

project(
  w3nco
  VERSION ${pVersion}
  LANGUAGES C Fortran)

if(NOT CMAKE_BUILD_TYPE MATCHES "^(Debug|Release|RelWithDebInfo|MinSizeRel)$")
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE
      "Release"
      CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
                                               "MinSizeRel" "RelWithDebInfo")
endif()

if(NOT CMAKE_C_COMPILER_ID MATCHES "^(Intel|GNU|Clang|AppleClang)$")
  message(WARNING "Compiler not officially supported: ${CMAKE_C_COMPILER_ID}")
endif()

if(APPLE)
  add_compile_definitions(APPLE)
elseif(UNIX)
  add_compile_definitions(LINUX)
endif()

if(CMAKE_C_COMPILER_ID MATCHES "^(Intel)$")
  set(CMAKE_C_FLAGS "-g")
  set(CMAKE_C_FLAGS_RELEASE "-O3")
  set(CMAKE_Fortran_FLAGS "-g")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
  set(fortran_d_flags "-r8")
  set(fortran_8_flags "-i8 -r8")
elseif(CMAKE_C_COMPILER_ID MATCHES "^(GNU|Clang|AppleClang)$")
  set(CMAKE_C_FLAGS "-ggdb")
  set(CMAKE_C_FLAGS_RELEASE "-O3")
  set(CMAKE_Fortran_FLAGS "-ggdb -fno-range-check -fbacktrace -funroll-loops")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
  set(fortran_d_flags "-fdefault-real-8")
  set(fortran_8_flags "-fdefault-integer-8 -fdefault-real-8")
endif()

add_subdirectory(src)

set_source_files_properties(${c_src} PROPERTIES COMPILE_OPTIONS "${c_flags}")
set_source_files_properties(${c_src} PROPERTIES COMPILE_DEFINITIONS
                                                "${platform_definitions}")

# One target for real32 and one target for real64
set(kinds "4" "8" "d")
foreach(kind ${kinds})
  set(lib_name ${PROJECT_NAME}_${kind})
  set(versioned_lib_name ${PROJECT_NAME}_v${PROJECT_VERSION}_${kind})

  add_library(${lib_name}_f OBJECT ${fortran_src})
  set_target_properties(${lib_name}_f PROPERTIES COMPILE_FLAGS
                                                 "${fortran_${kind}_flags}")
  add_library(${lib_name}_c OBJECT ${c_src})

  add_library(${lib_name} STATIC $<TARGET_OBJECTS:${lib_name}_f>
                                 $<TARGET_OBJECTS:${lib_name}_c>)
  set_target_properties(${lib_name} PROPERTIES OUTPUT_NAME
                                               ${versioned_lib_name})
  install(
    TARGETS ${lib_name}
    EXPORT ${PROJECT_NAME}-config
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)
endforeach()

install(EXPORT ${PROJECT_NAME}-config
        DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/${PROJECT_NAME})
