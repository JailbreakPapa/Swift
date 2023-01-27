# #####################################
# ## Vulkan support
# #####################################

set(CS_BUILD_EXPERIMENTAL_VULKAN OFF CACHE BOOL "Whether to enable experimental / work-in-progress Vulkan code")

# #####################################
# ## CS_requires_vulkan()
# #####################################
macro(CS_requires_vulkan)
	CS_requires_one_of(CS_CMAKE_PLATFORM_LINUX CS_CMAKE_PLATFORM_WINDOWS)
	CS_requires(CS_BUILD_EXPERIMENTAL_VULKAN)
	find_package(CSVulkan REQUIRED)
endmacro()

# #####################################
# ## CS_link_target_vulkan(<target>)
# #####################################
function(CS_link_target_vulkan TARGET_NAME)
	CS_requires_vulkan()

	find_package(CSVulkan REQUIRED)

	if(CSVULKAN_FOUND)
		target_link_libraries(${TARGET_NAME} PRIVATE CSVulkan::Loader)

		# Only on linux is the loader a dll.
		if(CS_CMAKE_PLATFORM_LINUX)
			get_target_property(_dll_location CSVulkan::Loader IMPORTED_LOCATION)

			if(NOT _dll_location STREQUAL "")
				add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
					COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:CSVulkan::Loader> $<TARGET_FILE_DIR:${TARGET_NAME}>)
			endif()

			unset(_dll_location)
		endif()
	endif()
endfunction()

# #####################################
# ## CS_link_target_dxc(<target>)
# #####################################
function(CS_link_target_dxc TARGET_NAME)
	CS_requires_vulkan()

	find_package(CSVulkan REQUIRED)

	if(CSVULKAN_FOUND)
		target_link_libraries(${TARGET_NAME} PRIVATE CSVulkan::DXC)

		get_target_property(_dll_location CSVulkan::DXC IMPORTED_LOCATION)

		if(NOT _dll_location STREQUAL "")
			add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
				COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:CSVulkan::DXC> $<TARGET_FILE_DIR:${TARGET_NAME}>)
		endif()

		unset(_dll_location)
	endif()
endfunction()

# #####################################
# ## CS_sources_target_spirv_reflect(<target>)
# #####################################
function(CS_sources_target_spirv_reflect TARGET_NAME)
	CS_requires_vulkan()

	find_package(CSVulkan REQUIRED)

	if(CSVULKAN_FOUND)
		target_include_directories(${TARGET_NAME} PRIVATE "${CS_VULKAN_DIR}/source/SPIRV-Reflect")
		target_sources(${TARGET_NAME} PRIVATE "${CS_VULKAN_DIR}/source/SPIRV-Reflect/spirv_reflect.h")
		target_sources(${TARGET_NAME} PRIVATE "${CS_VULKAN_DIR}/source/SPIRV-Reflect/spirv_reflect.c")
		source_group("SPIRV-Reflect" FILES "${CS_VULKAN_DIR}/source/SPIRV-Reflect/spirv_reflect.h" "${CS_VULKAN_DIR}/source/SPIRV-Reflect/spirv_reflect.c")
	endif()
endfunction()