ld_library_path="/var/vcap/packages/python-dev/apt/usr/lib"
if [ -n "${LD_LIBRARY_PATH:-}" ]; then
  export LD_LIBRARY_PATH="$ld_library_path:$LD_LIBRARY_PATH"
else
  export LD_LIBRARY_PATH="$ld_library_path"
fi

include_path="/var/vcap/packages/python-dev/apt/usr/include:/var/vcap/packages/python-dev/apt/usr/include/python2.7"
if [ -n "${INCLUDE_PATH:-}" ]; then
  export INCLUDE_PATH="$include_path:$INCLUDE_PATH"
else
  export INCLUDE_PATH="$include_path"
fi

export CPATH="$INCLUDE_PATH"
export CPPPATH="$INCLUDE_PATH"
