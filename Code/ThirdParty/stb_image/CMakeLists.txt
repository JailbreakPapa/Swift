cs_cmake_init()

# Get the name of this folder as the project name
get_filename_component(PROJECT_NAME ${CMAKE_CURRENT_SOURCE_DIR} NAME_WE)

cs_create_target(LIBRARY ${PROJECT_NAME} NO_CS_PREFIX)

