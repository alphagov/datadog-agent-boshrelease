export LD_LIBRARY_PATH="/var/vcap/packages/python-dev/apt/usr/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
export INCLUDE_PATH="/var/vcap/packages/python-dev/apt/usr/include:/var/vcap/packages/python-dev/apt/usr/include/python2.7${INCLUDE_PATH:+:${INCLUDE_PATH}}"
export CPATH="$INCLUDE_PATH"
export CPPPATH="$INCLUDE_PATH"
