cmake_minimum_required(VERSION 3.16)
project(w3nco VERSION 2.0.6)
set(${PROJECT_NAME}_VERSION ${PROJECT_VERSION} CACHE INTERNAL "${PROJECT_NAME} version number")
enable_language(Fortran)

if (NOT CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE RELEASE CACHE STRING
    "Choose the type of build, options are: PRODUCTION Debug Release." FORCE)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
  message("setting intel true")
  set(IntelComp true )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU*" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang*")
  set(GNUComp true )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "pgc*")
  set(PGIComp true )
endif()

STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "RelWithDebInfo" BUILD_RELEASE)
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "RELEASE" BUILD_RELEASE)
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "PRODUCTION" BUILD_PRODUCTION)
STRING(COMPARE EQUAL ${CMAKE_BUILD_TYPE} "DEBUG" BUILD_DEBUG)

if(APPLE)
  set(platform_definitions "APPLE")
else()
  set(platform_definitions "LINUX")
endif()

if( (BUILD_RELEASE) OR (BUILD_PRODUCTION) )
  if(IntelComp)
    set(shared_fortran_flags "-O3" "-g")    
    set(fortran_d_flags "-r8")
    set(fortran_8_flags "-r8" "-i8")
    set(fortran_4_flags)
    set(c_flags "-O3")
  elseif(GNUComp)
    set(shared_fortran_flags "-fno-range-check" "-O3" "-ggdb" "-funroll-loops")
    set(fortran_d_flags "-fdefault-real-8")
    set(fortran_8_flags "-fdefault-integer-8" "-fdefault-real-8")
    set(fortran_4_flags)
    set(c_flags "-O3")
  else()
    message("unknown compiler!")
    exit()
  endif()
endif()

file(GLOB fortran_src ${CMAKE_CURRENT_SOURCE_DIR}/src/*.f ${CMAKE_CURRENT_SOURCE_DIR}/src/*.F)
file(GLOB c_src ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c)
set_source_files_properties(${c_src} PROPERTIES COMPILE_OPTIONS "${c_flags}")
set_source_files_properties(${c_src} PROPERTIES COMPILE_DEFINITIONS "${platform_definitions}")

# One target for real32 and one target for real64
set(kinds "4" "8" "d")
foreach(kind ${kinds})
  set(lib_name ${PROJECT_NAME}_${kind})
  set(versioned_lib_name ${PROJECT_NAME}_v${PROJECT_VERSION}_${kind})
  add_library(${lib_name} STATIC ${fortran_src} ${c_src})
  set_target_properties(${lib_name} PROPERTIES OUTPUT_NAME "${versioned_lib_name}")
  
  set_source_files_properties(${fortran_src} PROPERTIES
    COMPILE_OPTIONS "${shared_fortran_flags};${fortran_${kind}_flags}")
  
  set(module_dir "${CMAKE_CURRENT_BINARY_DIR}/include_${kind}")
  set_target_properties(${lib_name} PROPERTIES Fortran_MODULE_DIRECTORY "${module_dir}")

  target_include_directories(${lib_name} PUBLIC
    $<BUILD_INTERFACE:${module_dir}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_PREFIX}/include_${kind}>)

  install(TARGETS ${lib_name}
    EXPORT ${PROJECT_NAME}-config
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib) 
  install(DIRECTORY ${module_dir} DESTINATION ${CMAKE_INSTALL_PREFIX})
endforeach()

install(EXPORT ${PROJECT_NAME}-config DESTINATION ${CMAKE_INSTALL_PREFIX})
