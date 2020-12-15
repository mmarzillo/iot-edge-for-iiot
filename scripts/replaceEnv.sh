#!/usr/bin/env bash

# Parsing arguments
inputFilePath=$1
outputFilePath=$2
envVariables=()
envVariableSubstitutes=()
#echo "Replacing file ${inputFilePath} with the following environment variables:"
for i in ${@:3}; do
    envVariables+=("\$$i")
    envVariableSubstitutes+=($(printenv $i))
    #echo "  $i=$(printenv $i)"
done

# Verifying that arguments look correct
if [ -z $inputFilePath ]; then
    echo "File path is missing. Exiting."
    exit 1
fi
if [ ! -f "${inputFilePath}" ]; then
    echo "File path does point at a valid file. Exiting."
    exit 1
fi
if [ -z $outputFilePath ]; then
    echo "Target file path is missing. Exiting."
    exit 1
fi
if [ -z $envVariables ]; then
    echo "Missing environment variables. Exiting."
    exit 1
fi

# Substituting the environment variables by their values:
sedInstruction=""
for ((i = 0; i < ${#envVariables[@]}; ++i)); do
    sedInstruction="${sedInstruction}s/${envVariables[i]}/${envVariableSubstitutes[i]}/;"
done
sed ${sedInstruction} $inputFilePath > $outputFilePath
#echo "Substitution made in file ${outputFilePath}."
