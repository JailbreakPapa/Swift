cmake_minimum_required(VERSION 3.20)

if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
	message(FATAL_ERROR "In-source builds are not supported. Please choose a different binary directory.")
	return()
endif()

include("${CMAKE_CURRENT_SOURCE_DIR}/csCMakeConfig.cmake")
get_property(CS_CMAKE_RELPATH GLOBAL PROPERTY CS_CMAKE_RELPATH)
get_property(CS_CMAKE_RELPATH_CODE GLOBAL PROPERTY CS_CMAKE_RELPATH_CODE)

# Required to find cmake modules like 'FindDirectX.cmake'
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/${CS_CMAKE_RELPATH}")
set(CS_HOME_DIR ${CMAKE_CURRENT_LIST_DIR})
include("${CMAKE_CURRENT_SOURCE_DIR}/Code/BuildSystem/CMake/csUtils.cmake")

file(RELATIVE_PATH CS_SUBMODULE_PREFIX_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
set_property(GLOBAL PROPERTY CS_SUBMODULE_PREFIX_PATH ${CS_SUBMODULE_PREFIX_PATH})

if(CS_SUBMODULE_PREFIX_PATH STREQUAL "")
	set(CS_SUBMODULE_MODE FALSE)
else()
	set(CS_SUBMODULE_MODE TRUE)
endif()

set_property(GLOBAL PROPERTY CS_SUBMODULE_MODE ${CS_SUBMODULE_MODE})

cs_build_filter_init()

cs_detect_project_name(DETECTED_NAME)

if(NOT CS_SUBMODULE_MODE)
	cs_detect_languages()

	set(CS_SOLUTION_NAME ${DETECTED_NAME} CACHE STRING "The name of the solution")
	project(${CS_SOLUTION_NAME}
		VERSION 1.0
		DESCRIPTION "Kura Studios In House Engine"
		HOMEPAGE_URL ""
		LANGUAGES ${CS_LANGUAGES})
endif()

cs_set_build_types()
cs_check_build_type()
cs_write_configuration_txt()

if(CS_CUSTOM_TOOLCHAIN_FILE)
	message(STATUS "Including CS_CUSTOM_TOOLCHAIN_FILE: '${CS_CUSTOM_TOOLCHAIN_FILE}'")
	include("${CS_CUSTOM_TOOLCHAIN_FILE}")
endif()

cs_pull_all_vars()

include("csPlatformVars")

set(CS_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Code")

cs_init_projects()

get_property(SELECTED_FILTER_NAME GLOBAL PROPERTY CS_BUILD_FILTER_SELECTED)
if (NOT ${SELECTED_FILTER_NAME} MATCHES "Everything")
	set(CMAKE_SUPPRESS_REGENERATION true)
endif()
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/Code)


if(NOT CS_SUBMODULE_MODE)
	if(TARGET Editor)
		# sets the Editor project as the default startup project in Visual Studio
		set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" PROPERTY VS_STARTUP_PROJECT Editor)
	endif()
endif()

# finalizers may run into problems in split solutions
# however, they aren't needed there, since CI will always build all projects
# and finalizers are typically only needed to set up build dependencies
if (${SELECTED_FILTER_NAME} MATCHES "Everything")
cs_finalize_projects()
endif()

get_property(EXPORT_PROJECTS GLOBAL PROPERTY "EXPORT_PROJECTS")
export(TARGETS ${EXPORT_PROJECTS} FILE "${CS_OUTPUT_DIRECTORY_DLL}/csExport.cmake")

set(EXPORT_INFO "
set(EXPINP_OUTPUT_DIRECTORY_DLL ${CS_OUTPUT_DIRECTORY_DLL})
set(EXPINP_OUTPUT_DIRECTORY_LIB ${CS_OUTPUT_DIRECTORY_LIB})
set(EXPINP_BINARY_DIR ${CMAKE_BINARY_DIR})
set(EXPINP_SOURCE_DIR ${CMAKE_SOURCE_DIR})
")

file(WRITE "${CS_OUTPUT_DIRECTORY_DLL}/csExportInfo.cmake" ${EXPORT_INFO})
