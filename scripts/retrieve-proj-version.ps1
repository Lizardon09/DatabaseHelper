cd ../ElasticSearchHelper.Infrastructure

$xml = [Xml] (Get-Content .\ElasticSearchHelper.Infrastructure.csproj)
if ($xml.Project.PropertyGroup -is [array]) {
  $version = $xml.Project.PropertyGroup[0].Version
}else {
  $version = $xml.Project.PropertyGroup.Version
}
cd ..
#we use encoding for null bytes
$version | Out-File -FilePath .\scripts\proj_version.txt -Encoding ASCII