set(PROJECT_NAME PCL)
set(VERSION 1.5.1)
set(BUILD_CONFIG "debug release")

if(BUILD_INSTALLERS)
    # if we're building installers, install PCL to a local folder
	set(CMAKE_ARGS -DBUILD_all_in_one_installer=ON -DBUILD_documentation=ON -DCMAKE_INSTALL_PREFIX=${ep_base}/Install/${PROJECT_NAME})
else()
	set(CMAKE_ARGS)
endif()

# append dependencies' root folders to CMAKE_ARGS
set(PCL_BUILT_DEPENDENCIES ${PCL_BUILT_DEPENDENCIES})
foreach(pcl_dep ${PCL_BUILT_DEPENDENCIES})
    set(CMAKE_ARGS ${CMAKE_ARGS} ${${pcl_dep}_root_cmake})
endforeach(pcl_dep)	

pcl_ExternalProject_Add(
   ${PROJECT_NAME}
   URL http://www.pointclouds.org/assets/files/${VERSION}/PCL-${VERSION}-Source.tar.bz2
   #SVN_REPOSITORY http://svn.pointclouds.org/pcl/trunk/
   #PATCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/patch-${VERSION}.patch"
   CMAKE_ARGS -DBUILD_TESTS=OFF -DBUILD_global_tests=OFF ${CMAKE_ARGS} 
   BUILD_COMMAND ${CMAKE_COMMAND} 
                 -DBUILD_PROJECT=${PROJECT_NAME} 
				 -DBUILD_CONFIG=${BUILD_CONFIG}
				 -DBUILD_TARGET=${TARGET_PROJECT}
				 -P "${PROJECT_SOURCE_DIR}/pcl_build_external_project.cmake"
   INSTALL_COMMAND ""
)



foreach(pcl_dep ${PCL_BUILT_DEPENDENCIES})
    add_dependencies(${PROJECT_NAME} ${pcl_dep})
endforeach(pcl_dep)

