string(REPLACE " " ";" BUILD_CONFIG_LIST ${BUILD_CONFIG})
set(BUILD_CONFIG_LIST ${BUILD_CONFIG_LIST})

list(LENGTH BUILD_CONFIG_LIST config_list_length)

if(WIN32)
    set(INSTALL_TARGET INSTALL)
	set(PACKAGE_TARGET PACKAGE)
else(WIN32)
    set(INSTALL_TARGET install)
	set(PACKAGE_TARGET package)
endif(WIN32)

# first, build the current project for all configurations
# On Windows, the INSTALL target triggers the build of all subprojects if needed.
# For PCL
foreach(config ${BUILD_CONFIG_LIST})
    # if we're building a PCL installer, no need to install PCL
    if(BUILD_PROJECT STREQUAL "PCL" AND BUILD_TARGET STREQUAL "PACKAGE")
		execute_process(
			COMMAND ${CMAKE_COMMAND}
				--build . --config ${config}
		)    
	else(BUILD_PROJECT STREQUAL "PCL" AND BUILD_TARGET STREQUAL "PACKAGE")
		execute_process(
			COMMAND ${CMAKE_COMMAND}
				--build . --config ${config} --target ${INSTALL_TARGET}
		)
	endif(BUILD_PROJECT STREQUAL "PCL" AND BUILD_TARGET STREQUAL "PACKAGE")
endforeach(config)

# a hack to be able to build one nsis installer for multiple build configurations
macro(merge_cmake_install)
	file(GLOB_RECURSE cmake_install_files "cmake_install.cmake")
	foreach(file ${cmake_install_files})
		get_filename_component(file_path "${file}" PATH) 
		file(RENAME "${file}" "${file_path}/cmake_install.cmake.bak")
		file(READ "${file_path}/cmake_install.cmake.bak" contents)
		string(REPLACE "ENDIF(\"\${CMAKE_INSTALL_CONFIG_NAME}\" MATCHES \"^([Dd][Ee][Bb][Uu][Gg])$\")" "" contents "${contents}")
		string(REPLACE "IF(\"\${CMAKE_INSTALL_CONFIG_NAME}\" MATCHES \"^([Dd][Ee][Bb][Uu][Gg])$\")" "" contents "${contents}")
		string(REPLACE "ENDIF(\"\${CMAKE_INSTALL_CONFIG_NAME}\" MATCHES \"^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$\")" "" contents "${contents}")
		string(REPLACE "ELSEIF(\"\${CMAKE_INSTALL_CONFIG_NAME}\" MATCHES \"^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$\")" "" contents "${contents}")
		string(REPLACE "IF(\"\${CMAKE_INSTALL_CONFIG_NAME}\" MATCHES \"^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$\")" "" contents "${contents}")
		string(REPLACE "ELSEIF(\"\${CMAKE_INSTALL_CONFIG_NAME}\" MATCHES \"^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$\")" "IF(\"\${CMAKE_INSTALL_CONFIG_NAME}\" MATCHES \"^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$\")" contents "${contents}")
		file(WRITE "${file}" "${contents}")
	endforeach(file)
endmacro(merge_cmake_install)

# Build installer ? 
if(BUILD_TARGET STREQUAL PACKAGE)
    # for PCL, we need to trigger explicetely the doxygen documentation and Tutorials'
	# tragets, because they are not triggered by the INSTALL/ALL_BUILD target.
	# these targets need Doxygen, Sphinx, etc.. 
    if(BUILD_PROJECT STREQUAL "PCL")
		execute_process(
			COMMAND ${CMAKE_COMMAND}
				--build . --config release --target doc
		)    
		execute_process(
			COMMAND ${CMAKE_COMMAND}
				--build . --config release --target Tutorials
		) 
	endif(BUILD_PROJECT STREQUAL "PCL")
	
	# if we are On Windows, and the current project is build for multiple configurations
    if(WIN32 AND config_list_length GREATER 1) # merge
		merge_cmake_install()
		set(TARGET PACKAGE)
	endif(WIN32 AND config_list_length GREATER 1)
	execute_process(
        COMMAND ${CMAKE_COMMAND}
            --build . --config release --target ${PACKAGE_TARGET}
    )
endif(BUILD_TARGET STREQUAL PACKAGE)

