#!/bin/bash
set -e

# Clean up existing packages
find src -name "*.nupkg" -delete

# Pack the solution
# EnableWindowsTargeting=true is usually needed if some projects target WPF/Windows
dotnet pack RoslynPad.slnx -c Release -p:EnableWindowsTargeting=true -p:ContinuousIntegrationBuild=true

# Ask for API key
read -p "Enter nuget.org API key: " api_key

# Push packages
# Use find to locate all nupkg files in the src directory tree
find src -name "*.nupkg" | while read -r package; do
    echo "Pushing $package..."
    dotnet nuget push "$package" --source https://api.nuget.org/v3/index.json --api-key "$api_key"
done
