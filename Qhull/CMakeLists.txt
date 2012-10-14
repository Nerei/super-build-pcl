set(PROJECT_NAME Qhull)
set(VERSION 2011.1)
set(BUILD_CONFIG "debug release")

if(BUILD_INSTALLERS)
    set(CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ep_base}/Install/${PROJECT_NAME})
	set(${PROJECT_NAME}_root_cmake -DQHULL_ROOT=${ep_base}/Install/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
else()
    set(CMAKE_ARGS)
	# this applies only for Windows
	set(${PROJECT_NAME}_root_cmake -DQHULL_ROOT=${INSTALL_PREFIX}/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
endif()

pcl_ExternalProject_Add(
   ${PROJECT_NAME}
   URL http://www.qhull.org/download/qhull-${VERSION}.zip
   PATCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cpack-${VERSION}.patch"
   CMAKE_ARGS ${CMAKE_ARGS}
   BUILD_COMMAND ${CMAKE_COMMAND} 
                 -DBUILD_PROJECT=${PROJECT_NAME} 
				 -DBUILD_CONFIG=${BUILD_CONFIG}
				 -DBUILD_TARGET=${TARGET_PROJECT}
				 -P "${PROJECT_SOURCE_DIR}/pcl_build_external_project.cmake"
   INSTALL_COMMAND ""
)
