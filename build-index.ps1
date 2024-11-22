# create by Ákos Nikházy https://yzahk.in

#
# INI
#

# your template files
$HTMLtemplatePath = "index-template.html" # change this file to design your index
$PosttemplatePath = "post-template.html" # change this to design your post items in the index
$RSStemplatePath = "rss-template.xml" # you might add other RSS XML tags in this
$SitemaptemplatePath = "sitemap-template.xml" # you might add other sitmeap tags in this

# folder of posts. You put subfolders and html files in this. It is designed
# so subfolders are named as Y-m-d, so it is the date of posting in the html file.
# example folder structure posts/2025-02-12/post-title.html
$contentFolderPath = "posts"

# without / at the end!
$domain = "http://example.com"

#
# Work
#

$HTMLOutput = "index.html"
$RSSOutput = "rss.xml"
$SitemapOutput = "sitemap.xml"

# loading the template files
$HTMLtemplateContent = Get-Content -Path $HTMLtemplatePath -Raw
$RSStemplateContent = Get-Content -Path $RSStemplatePath -Raw
$SitemaptemplateContent = Get-Content -Path $SitemaptemplatePath -Raw
$postContent = Get-Content -Path $PosttemplatePath -Raw

# loading the html posts and their folders
$directories = Get-ChildItem -Path $contentFolderPath -Directory | Sort-Object Name -Descending

$htmlFiles = @()

foreach ($dir in $directories) {
    $htmlFiles += Get-ChildItem -Path $dir.FullName -Filter "*.html"
}

# building the files
$HTMLListContent = ""
$RSSListContent = ""
$SitemapListContent = ""

$postCount = 0

foreach ($htmlFile in $htmlFiles) {
   
    $containingFolder = $htmlFile.Directory.Name
    
    $htmlContent = Get-Content -Path $htmlFile.FullName -Raw
     
    $h1Text = "No Title"
    if ($htmlContent -match '<h1>(.*?)</h1>') {
        $h1Text = $matches[1]
    }

    $pText = 'A post about ' + $h1Text
    if ($htmlContent -match '<p>(.*?)</p>') {
        $pText = $matches[1]
    }



    $relativePath = "$containingFolder/$htmlFile"

    $postText = $postContent

    $postText = $postText -replace "\{\{path\}\}",$relativePath
    $postText = $postText -replace "\{\{title\}\}", $h1Text
    $postText = $postText -replace "\{\{date\}\}", $containingFolder
    $postText = $postText -replace "\{\{text\}\}", $pText

    $HTMLListContent +=   $postText

    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $guid =  [BitConverter]::ToString($sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($h1Text + $containingFolder + $relativePath))) -replace '-'

    # to do: make RSS post template
    $pText = $pText -replace '<[^>]*>', ''
    $RSSListContent += '<item><guid isPermaLink="false">' + $guid + '</guid><title>' + $h1Text + '</title><link>' + $domain + '/' + $contentFolderPath + '/' + $relativePath + '</link><description>' + $pText + '</description></item>'

    # to do: make sitemap post template
    $SitemapListContent += "<url><loc>$domain/$contentFolderPath/$containingFolder/$htmlFile</loc><lastmod>$containingFolder</lastmod></url>"

    $postCount++
}

$HTMLtemplateContent = $HTMLtemplateContent -replace "\{\{list\}\}", $HTMLListContent
$RSStemplateContent = $RSStemplateContent -replace "\{\{items\}\}", $RSSListContent
$SitemaptemplateContent = $SitemaptemplateContent -replace "\{\{urls\}\}", $SitemapListContent

Set-Content -Path $HTMLOutput -Value $HTMLtemplateContent
Set-Content -Path $RSSOutput -Value $RSStemplateContent
Set-Content -Path $SitemapOutput -Value $SitemaptemplateContent
Write-Host "$HTMLOutput, $RSSOutput and $SitemapOutput built with $postCount post(s)"
