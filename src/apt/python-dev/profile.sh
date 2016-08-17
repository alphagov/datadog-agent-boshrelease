export LD_LIBRARY_PATH="/var/vcap/packages/python-dev/apt/usr/lib:${LD_LIBRARY_PATH:-}"
export INCLUDE_PATH="/var/vcap/packages/python-dev/apt/usr/include:${INCLUDE_PATH:-}"
export CPATH="$INCLUDE_PATH"
export CPPPATH="$INCLUDE_PATH"
