# find the folder into which the Vulkan SDK has been installed

# early out, if this target has been created before
if((TARGET CSVulkan::Loader) AND(TARGET CSVulkan::DXC))
	return()
endif()

set(CS_VULKAN_DIR $ENV{VULKAN_SDK} CACHE PATH "Directory of the Vulkan SDK")

CS_pull_compiler_and_architecture_vars()
CS_pull_config_vars()

get_property(CS_SUBMODULE_PREFIX_PATH GLOBAL PROPERTY CS_SUBMODULE_PREFIX_PATH)

if(CS_CMAKE_PLATFORM_WINDOWS_DESKTOP AND CS_CMAKE_ARCHITECTURE_64BIT)
	if((CS_VULKAN_DIR STREQUAL "CS_VULKAN_DIR-NOTFOUND") OR(CS_VULKAN_DIR STREQUAL ""))
		# set(CMAKE_FIND_DEBUG_MODE TRUE)
		unset(CS_VULKAN_DIR CACHE)
		unset(CSVulkan_DIR CACHE)
		find_path(CS_VULKAN_DIR Config/vk_layer_settings.txt
			PATHS
			${CS_VULKAN_DIR}
			$ENV{VULKAN_SDK}
			REQUIRED
		)

		# set(CMAKE_FIND_DEBUG_MODE FALSE)
	endif()
elseif(CS_CMAKE_PLATFORM_LINUX AND CS_CMAKE_ARCHITECTURE_64BIT)
	if((CS_VULKAN_DIR STREQUAL "CS_VULKAN_DIR-NOTFOUND") OR(CS_VULKAN_DIR STREQUAL ""))
		# set(CMAKE_FIND_DEBUG_MODE TRUE)
		unset(CS_VULKAN_DIR CACHE)
		unset(CSVulkan_DIR CACHE)
		find_path(CS_VULKAN_DIR config/vk_layer_settings.txt
			PATHS
			${CS_VULKAN_DIR}
			$ENV{VULKAN_SDK}
		)

		if(CS_CMAKE_ARCHITECTURE_X86)
			if((CS_VULKAN_DIR STREQUAL "CS_VULKAN_DIR-NOTFOUND") OR (CS_VULKAN_DIR STREQUAL ""))
				CS_download_and_extract("${CS_CONFIG_VULKAN_SDK_LINUXX64_URL}" "${CMAKE_BINARY_DIR}/vulkan-sdk" "vulkan-sdk-${CS_CONFIG_VULKAN_SDK_LINUXX64_VERSION}")
				set(CS_VULKAN_DIR "${CMAKE_BINARY_DIR}/vulkan-sdk/${CS_CONFIG_VULKAN_SDK_LINUXX64_VERSION}" CACHE PATH "Directory of the Vulkan SDK" FORCE)

				find_path(CS_VULKAN_DIR config/vk_layer_settings.txt
					PATHS
					${CS_VULKAN_DIR}
					$ENV{VULKAN_SDK}
				)
			endif()
		endif()

		if((CS_VULKAN_DIR STREQUAL "CS_VULKAN_DIR-NOTFOUND") OR (CS_VULKAN_DIR STREQUAL ""))
			message(FATAL_ERROR "Failed to find vulkan SDK. CS requires the vulkan sdk ${CS_CONFIG_VULKAN_SDK_LINUXX64_VERSION}. Please set the environment variable VULKAN_SDK to the vulkan sdk location.")
		endif()

		# set(CMAKE_FIND_DEBUG_MODE FALSE)
	endif()
else()
	message(FATAL_ERROR "TODO: Vulkan is not yet supported on this platform and/or architecture.")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CSVulkan DEFAULT_MSG CS_VULKAN_DIR)

if(CSVULKAN_FOUND)
	if(CS_CMAKE_PLATFORM_WINDOWS_DESKTOP AND CS_CMAKE_ARCHITECTURE_64BIT)
		add_library(CSVulkan::Loader STATIC IMPORTED)
		set_target_properties(CSVulkan::Loader PROPERTIES IMPORTED_LOCATION "${CS_VULKAN_DIR}/Lib/vulkan-1.lib")
		set_target_properties(CSVulkan::Loader PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CS_VULKAN_DIR}/Include")

		add_library(CSVulkan::DXC SHARED IMPORTED)
		set_target_properties(CSVulkan::DXC PROPERTIES IMPORTED_LOCATION "${CS_VULKAN_DIR}/Bin/dxcompiler.dll")
		set_target_properties(CSVulkan::DXC PROPERTIES IMPORTED_IMPLIB "${CS_VULKAN_DIR}/Lib/dxcompiler.lib")
		set_target_properties(CSVulkan::DXC PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CS_VULKAN_DIR}/Include")

	elseif(CS_CMAKE_PLATFORM_LINUX AND CS_CMAKE_ARCHITECTURE_64BIT)
		add_library(CSVulkan::Loader SHARED IMPORTED)
		set_target_properties(CSVulkan::Loader PROPERTIES IMPORTED_LOCATION "${CS_VULKAN_DIR}/x86_64/lib/libvulkan.so.1.3.216")
		set_target_properties(CSVulkan::Loader PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CS_VULKAN_DIR}/x86_64/include")

		add_library(CSVulkan::DXC SHARED IMPORTED)
		set_target_properties(CSVulkan::DXC PROPERTIES IMPORTED_LOCATION "${CS_VULKAN_DIR}/x86_64/lib/libdxcompiler.so.3.7")
		set_target_properties(CSVulkan::DXC PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CS_VULKAN_DIR}/x86_64/include")
	else()
		message(FATAL_ERROR "TODO: Vulkan is not yet supported on this platform and/or architecture.")
	endif()
endif()
