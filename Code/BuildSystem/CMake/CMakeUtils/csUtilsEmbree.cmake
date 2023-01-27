# #####################################
# ## Embree support
# #####################################

set(CS_BUILD_EMBREE OFF CACHE BOOL "Whether support for Intel Embree should be added")

# #####################################
# ## CS_requires_embree()
# #####################################
macro(CS_requires_embree)
	CS_requires_windows()
	CS_requires(CS_BUILD_EMBREE)
endmacro()

# #####################################
# ## CS_link_target_embree(<target>)
# #####################################
function(CS_link_target_embree TARGET_NAME)
	CS_requires_embree()

	find_package(CSEmbree REQUIRED)

	if(CSEMBREE_FOUND)
		target_link_libraries(${TARGET_NAME} PRIVATE CSEmbree::CSEmbree)

		target_compile_definitions(${PROJECT_NAME} PUBLIC BUILDSYSTEM_ENABLE_EMBREE_SUPPORT)

		add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
			COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:CSEmbree::CSEmbree> $<TARGET_FILE_DIR:${TARGET_NAME}>
		)
	endif()
endfunction()
