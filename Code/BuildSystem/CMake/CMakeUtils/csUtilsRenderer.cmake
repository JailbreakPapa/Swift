# #####################################
# ## CS_requires_renderer()
# #####################################

macro(CS_requires_renderer)
	if(CS_CMAKE_PLATFORM_WINDOWS)
		CS_requires_d3d()
	else()
		CS_requires_vulkan()
	endif()
endmacro()

# #####################################
# ## CS_add_renderers(<target>)
# ## Add all required libraries and dependencies to the given target so it has accedss to all available renderers.
# #####################################
function(CS_add_renderers TARGET_NAME)
	if(CS_BUILD_EXPERIMENTAL_VULKAN)
		target_link_libraries(${TARGET_NAME}
			PRIVATE
			RendererVulkan
		)

		add_dependencies(${TARGET_NAME}
			ShaderCompilerDXC
		)
	endif()

	if(CS_CMAKE_PLATFORM_WINDOWS)
		target_link_libraries(${TARGET_NAME}
			PRIVATE
			RendererDX11
		)
		CS_link_target_dx11(${TARGET_NAME})

		add_dependencies(${TARGET_NAME}
			ShaderCompilerHLSL
		)
	endif()
endfunction()