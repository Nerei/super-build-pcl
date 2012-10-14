set(PROJECT_NAME Eigen)
set(VERSION 3.0.5)
set(BUILD_CONFIG release)

if(BUILD_INSTALLERS)
    set(CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${ep_base}/Install/${PROJECT_NAME})
	set(${PROJECT_NAME}_root_cmake -DEIGEN_ROOT=${ep_base}/Install/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
else()
    set(CMAKE_ARGS)
	# this applies only for Windows
	set(${PROJECT_NAME}_root_cmake -DEIGEN_ROOT=${INSTALL_PREFIX}/${PROJECT_NAME} CACHE STRING "${PROJECT_NAME} root" FORCE)
endif()

pcl_ExternalProject_Add(
   ${PROJECT_NAME}
   URL http://bitbucket.org/eigen/eigen/get/${VERSION}.tar.bz2
   PATCH_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cpack-${VERSION}.patch"
   CMAKE_ARGS ${CMAKE_ARGS}
   BUILD_COMMAND ${CMAKE_COMMAND} 
                 -DBUILD_PROJECT=${PROJECT_NAME} 
				 -DBUILD_CONFIG=${BUILD_CONFIG}
				 -DBUILD_TARGET=${TARGET_PROJECT}
				 -P "${PROJECT_SOURCE_DIR}/pcl_build_external_project.cmake"
   INSTALL_COMMAND ""
)
