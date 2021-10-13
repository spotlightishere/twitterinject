run:
	clang -fmodules -shared -Wall -Os -o libtwitterinject.dylib twitterinject.m
	DYLD_INSERT_LIBRARIES=`pwd`/libtwitterinject.dylib /Applications/Twitter.app/Contents/MacOS/Twitter
