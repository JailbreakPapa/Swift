# find the folder into which the OpenXR loader has been installed

# early out, if this target has been created before
if(TARGET CSOpenXR::Loader)
	return()
endif()

set(CS_OPENXR_LOADER_DIR "CS_OPENXR_LOADER_DIR-NOTFOUND" CACHE PATH "Directory of OpenXR loader installation")
set(CS_OPENXR_HEADERS_DIR "CS_OPENXR_HEADERS_DIR-NOTFOUND" CACHE PATH "Directory of OpenXR headers installation")
set(CS_OPENXR_PREVIEW_DIR "" CACHE PATH "Directory of OpenXR preview include root")
set(CS_OPENXR_REMOTING_DIR "" CACHE PATH "Directory of OpenXR remoting installation")
mark_as_advanced(FORCE CS_OPENXR_LOADER_DIR)
mark_as_advanced(FORCE CS_OPENXR_HEADERS_DIR)
mark_as_advanced(FORCE CS_OPENXR_PREVIEW_DIR)
mark_as_advanced(FORCE CS_OPENXR_REMOTING_DIR)

CS_pull_compiler_and_architecture_vars()

if((CS_OPENXR_LOADER_DIR STREQUAL "CS_OPENXR_LOADER_DIR-NOTFOUND") OR(CS_OPENXR_LOADER_DIR STREQUAL "") OR(CS_OPENXR_HEADERS_DIR STREQUAL "CS_OPENXR_HEADERS_DIR-NOTFOUND") OR(CS_OPENXR_HEADERS_DIR STREQUAL "") OR(CS_OPENXR_REMOTING_DIR STREQUAL "CS_OPENXR_REMOTING_DIR-NOTFOUND") OR(CS_OPENXR_REMOTING_DIR STREQUAL ""))
	CS_nuget_init()
	execute_process(COMMAND ${NUGET} restore ${CMAKE_SOURCE_DIR}/Code/EnginePlugins/OpenXRPlugin/packages.config -PackagesDirectory ${CMAKE_BINARY_DIR}/packages
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
	set(CS_OPENXR_LOADER_DIR "${CMAKE_BINARY_DIR}/packages/OpenXR.Loader.1.0.10.2" CACHE PATH "Directory of OpenXR loader installation" FORCE)
	set(CS_OPENXR_HEADERS_DIR "${CMAKE_BINARY_DIR}/packages/OpenXR.Headers.1.0.10.2" CACHE PATH "Directory of OpenXR headers installation" FORCE)
	set(CS_OPENXR_REMOTING_DIR "${CMAKE_BINARY_DIR}/packages/Microsoft.Holographic.Remoting.OpenXr.2.4.0" CACHE PATH "Directory of OpenXR remoting installation" FORCE)
endif()

if(CS_CMAKE_PLATFORM_WINDOWS_UWP)
	set(OPENXR_DYNAMIC ON)
	find_path(CS_OPENXR_HEADERS_DIR include/openxr/openxr.h)

	if(CS_CMAKE_ARCHITECTURE_ARM)
		if(CS_CMAKE_ARCHITECTURE_64BIT)
			set(OPENXR_BIN_PREFIX "arm64_uwp")
		else()
			set(OPENXR_BIN_PREFIX "arm_uwp")
		endif()
	else()
		if(CS_CMAKE_ARCHITECTURE_64BIT)
			set(OPENXR_BIN_PREFIX "x64_uwp")
		else()
			set(OPENXR_BIN_PREFIX "Win32_uwp")
		endif()
	endif()

elseif(CS_CMAKE_PLATFORM_WINDOWS_DESKTOP)
	set(OPENXR_DYNAMIC ON)
	find_path(CS_OPENXR_HEADERS_DIR include/openxr/openxr.h)

	if(CS_CMAKE_ARCHITECTURE_64BIT)
		set(OPENXR_BIN_PREFIX "x64")
		find_path(CS_OPENXR_REMOTING_DIR build/native/include/openxr/openxr_msft_holographic_remoting.h)
	else()
		set(OPENXR_BIN_PREFIX "Win32")
	endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CSOpenXR DEFAULT_MSG CS_OPENXR_LOADER_DIR)
find_package_handle_standard_args(CSOpenXR DEFAULT_MSG CS_OPENXR_HEADERS_DIR)
find_package_handle_standard_args(CSOpenXR DEFAULT_MSG CS_OPENXR_REMOTING_DIR)

if(CSOPENXR_FOUND)
	add_library(CSOpenXR::Loader SHARED IMPORTED)

	if(OPENXR_DYNAMIC)
		set_target_properties(CSOpenXR::Loader PROPERTIES IMPORTED_LOCATION "${CS_OPENXR_LOADER_DIR}/native/${OPENXR_BIN_PREFIX}/release/bin/openxr_loader.dll")
		set_target_properties(CSOpenXR::Loader PROPERTIES IMPORTED_LOCATION_DEBUG "${CS_OPENXR_LOADER_DIR}/native/${OPENXR_BIN_PREFIX}/release/bin/openxr_loader.dll")
	endif()

	set_target_properties(CSOpenXR::Loader PROPERTIES IMPORTED_IMPLIB "${CS_OPENXR_LOADER_DIR}/native/${OPENXR_BIN_PREFIX}/release/lib/openxr_loader.lib")
	set_target_properties(CSOpenXR::Loader PROPERTIES IMPORTED_IMPLIB_DEBUG "${CS_OPENXR_LOADER_DIR}/native/${OPENXR_BIN_PREFIX}/release/lib/openxr_loader.lib")

	set_target_properties(CSOpenXR::Loader PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CS_OPENXR_HEADERS_DIR}/include")

	if(NOT CS_OPENXR_PREVIEW_DIR STREQUAL "")
		set_target_properties(CSOpenXR::Loader PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CS_OPENXR_HEADERS_DIR}/include")
	endif()

	if(CS_CMAKE_PLATFORM_WINDOWS_DESKTOP AND CS_CMAKE_ARCHITECTURE_64BIT)
		# As this is a windows only library, we are relying on the .targets file to handle to includes / imports.
		add_library(CSOpenXR::Remoting SHARED IMPORTED)
		set_target_properties(CSOpenXR::Remoting PROPERTIES IMPORTED_LOCATION ${CS_OPENXR_REMOTING_DIR}/build/native/Microsoft.Holographic.Remoting.OpenXr.targets)
	endif()

	CS_uwp_mark_import_as_content(CSOpenXR::Loader)
endif()

unset(OPENXR_DYNAMIC)
unset(OPENXR_BIN_PREFIX)
