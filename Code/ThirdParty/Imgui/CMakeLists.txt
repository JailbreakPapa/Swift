cs_cmake_init()



cs_requires(CS_3RDPARTY_IMGUI_SUPPORT)

# Get the name of this folder as the project name
get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)

cs_create_target(SHARED_LIBRARY ${PROJECT_NAME} NO_CS_PREFIX)

target_compile_definitions(${PROJECT_NAME} PUBLIC BUILDSYSTEM_ENABLE_IMGUI_SUPPORT)

