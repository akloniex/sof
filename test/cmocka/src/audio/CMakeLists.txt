# SPDX-License-Identifier: BSD-3-Clause

add_subdirectory(buffer)
add_subdirectory(component)
add_subdirectory(pcm_converter)
if(CONFIG_COMP_MIXER)
	add_subdirectory(mixer)
endif()
add_subdirectory(pipeline)

