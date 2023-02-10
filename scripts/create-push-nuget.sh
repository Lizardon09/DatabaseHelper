#!/bin/sh
set -e

unalias -a
shopt -s expand_aliases
alias cleanecho='{ set +x; } 2>/dev/null; resetx_after echo'
resetx_after() { "$@"; set -x; }

read -p 'Nuget_Api_Key: ' apiKey

set -x
cd ./scripts

osType=$OSTYPE
cleanecho -e "\nDetected OS Type: ${osType}\n"

#Script to retrieve project version
if [[ "$osType" == "linux-gnu"* ]]; then
	pwsh ./retrieve-proj-version.ps1
else
	powershell ./retrieve-proj-version.ps1
fi
cleanecho -e '\nasserted project version...\n'

filename=proj_version.txt
proj_version=$(cat $filename)
cleanecho -e "\nproject version ${proj_version} detected...\n"

cleanecho -e '\nstarting project packaging...'
#Create nuget package
dotnet pack ../DatabaseHelper.Infrastructure/DatabaseHelper.Infrastructure.csproj -o ../bin/Publish/Nuget/
cleanecho -e 'project packaging successfull...\n'

cleanecho -e '\nattempting package push to nuget.org...'
#Push nuget package with api key
nuget push ../bin/Publish/Nuget/DragonCore.DatabaseHelper.${proj_version}.nupkg $apiKey -Source https://api.nuget.org/v3/index.json
cleanecho -e 'package pushed successfully!'