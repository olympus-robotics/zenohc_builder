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

set(ZENOHC_BUILD_WITH_UNSTABLE_API TRUE)
set(ZENOHC_BUILD_WITH_SHARED_MEMORY TRUE)


if(NOT TARGET __zenohc_shared)
    add_library(__zenohc_shared SHARED IMPORTED GLOBAL)
    add_library(zenohc::shared ALIAS __zenohc_shared)
    set_target_properties(__zenohc_shared PROPERTIES
        INTERFACE_COMPILE_DEFINITION ZENOHC_DYN_LIB
        IMPORTED_LOCATION "${PACKAGE_PREFIX_DIR}/lib/libzenohc.so"
        INTERFACE_INCLUDE_DIRECTORIES "${PACKAGE_PREFIX_DIR}/include"
    )
    if(NOT ("" STREQUAL ""))
        set_property(TARGET __zenohc_shared PROPERTY IMPORTED_IMPLIB "${PACKAGE_PREFIX_DIR}/lib/")
    endif()
endif()
if(NOT TARGET __zenohc_static)
    add_library(__zenohc_static STATIC IMPORTED GLOBAL)
    add_library(zenohc::static ALIAS __zenohc_static)
    target_link_libraries(__zenohc_static INTERFACE rt;pthread;m;dl)
    set_target_properties(__zenohc_static PROPERTIES
        IMPORTED_LOCATION "${PACKAGE_PREFIX_DIR}/lib/libzenohc.a"
        INTERFACE_INCLUDE_DIRECTORIES "${PACKAGE_PREFIX_DIR}/include"
    )
endif()

if(NOT TARGET zenohc::lib)
    if(TRUE)
        add_library(zenohc::lib ALIAS __zenohc_shared)
    else()
        add_library(zenohc::lib ALIAS __zenohc_static)
    endif()
endif()
