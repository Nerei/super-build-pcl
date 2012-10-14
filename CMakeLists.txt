cmake_minimum_required(VERSION 2.8)

project(SuperBuild)

set(CMAKE_CONFIGURATION_TYPES "Release" CACHE STRING "possible configurations" FORCE)

set(ep_base "${CMAKE_BINARY_DIR}/CMakeExternal" CACHE INTERNAL "")

option(BUILD_INSTALLERS "If checked, installers will be built. If unchecked, libraries will be installed" OFF)

if(BUILD_INSTALLERS)
    set(TARGET_PROJECT PACKAGE)
    SET_PROPERTY(DIRECTORY PROPERTY EP_BASE "${ep_base}")
else(BUILD_INSTALLERS)
    set(TARGET_PROJECT INSTALL)
    SET_PROPERTY(DIRECTORY PROPERTY EP_BASE)
endif(BUILD_INSTALLERS)

include("${CMAKE_CURRENT_SOURCE_DIR}/pcl_ExternalProject.cmake")

get_filename_component(INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}" PATH)

set(PCL_BUILT_DEPENDENCIES "" CACHE INTERNAL "")
foreach(dependency 
    Boost
	#cminpack
    Eigen
    Flann
    Qhull
	VTK
    )
    option(BUILD_${dependency} "Build ${dependency}" ON)
    if(BUILD_${dependency})
	    list(APPEND PCL_BUILT_DEPENDENCIES ${dependency})
        add_subdirectory(${dependency})
    endif(BUILD_${dependency})
endforeach(dependency)

option(BUILD_PCL "Build PCL" ON)
if(BUILD_PCL)
    add_subdirectory(PCL)
endif(BUILD_PCL)
