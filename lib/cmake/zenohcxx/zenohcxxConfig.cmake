#
# Copyright (c) 2022 ZettaScale Technology.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0, or the Apache License, Version 2.0
# which is available at https://www.apache.org/licenses/LICENSE-2.0.
#
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
#
# Contributors:
#   ZettaScale Zenoh team, <zenoh@zettascale.tech>
#


####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was PackageConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

macro(set_and_check _var _file)
  set(${_var} "${_file}")
  if(NOT EXISTS "${_file}")
    message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
  endif()
endmacro()

macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT ${_NAME}_${comp}_FOUND)
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

####################################################################################

# Compute the installation prefix relative to this file.
get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
if(_IMPORT_PREFIX STREQUAL "/")
  set(_IMPORT_PREFIX "")
endif()

if(NOT TARGET zenohcxx)
	add_library(zenohcxx INTERFACE IMPORTED)
	target_include_directories(zenohcxx INTERFACE "${_IMPORT_PREFIX}/include")
endif()

# zenohcxx for zenohpico
if(TARGET zenohpico::lib AND NOT TARGET zenohcxx_zenohpico)
	message(STATUS "defined lib target zenohcxx::zenohpico for zenohpico::lib")
	add_library(zenohcxx_zenohpico INTERFACE IMPORTED)
	target_compile_definitions(zenohcxx_zenohpico INTERFACE ZENOHCXX_ZENOHPICO)
    target_include_directories(zenohcxx_zenohpico INTERFACE "${_IMPORT_PREFIX}/include")
	add_dependencies(zenohcxx_zenohpico zenohpico::lib)
	target_link_libraries(zenohcxx_zenohpico INTERFACE zenohpico::lib)
	add_library(zenohcxx::zenohpico ALIAS zenohcxx_zenohpico)
endif()

# zenohcxx for zenohc static/dynamic depending on ZENOHC_LIB_STATIC
if(TARGET zenohc::lib AND NOT TARGET zenohcxx_zenohc)
	message(STATUS "defined lib target zenohcxx::zenohc for zenohc::lib")
	add_library(zenohcxx_zenohc INTERFACE IMPORTED)
	target_compile_definitions(zenohcxx_zenohc INTERFACE ZENOHCXX_ZENOHC)
    target_include_directories(zenohcxx_zenohc INTERFACE "${_IMPORT_PREFIX}/include")
	add_dependencies(zenohcxx_zenohc zenohc::lib)
	target_link_libraries(zenohcxx_zenohc INTERFACE zenohc::lib)
	add_library(zenohcxx::zenohc ALIAS zenohcxx_zenohc)
endif()

if(NOT TARGET zenohcxx_zenohpico AND NOT TARGET zenohcxx_zenohc)
	message(FATAL_ERROR "Failed to detect zenoh-cpp backend, you need to have either zenoh-c or zenoh-pico installed" )
endif()