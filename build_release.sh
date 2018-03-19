#!/bin/bash

cd $(dirname $0)

echo $PWD
configuration=Release
projectName=MagicalRecord

for scheme in 'MagicalRecord static library for iOS'; do
    xcodebuild                                                      \
        -workspace $projectName.xcodeproj/project.xcworkspace       \
        -scheme "$scheme"                                           \
        -destination 'platform=iOS Simulator,name=iPhone SE'         \
        -destination 'generic/platform=iOS'                         \
        -configuration $configuration                               \
        SYMROOT="$PWD/build"                                        \
        ;
done

if (($? == 0)); then
    echo "create universal libs"

    cd build
    if [[ ! -d $projectName ]] ; then
        mkdir $projectName
    fi

    for lib in $(cd $configuration-iphoneos; ls *.a); do
        echo "create universal lib $lib"
        lipo -create -output $projectName/"$lib" \
            $configuration-iphoneos/"$lib" $configuration-iphonesimulator/"$lib"
    done

    cp -r $configuration-iphoneos/include $projectName

    echo "create universal libs done!"
fi

