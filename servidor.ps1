Add-Type -AssemblyName System.Web
$port = 5000
$folder = $PSScriptRoot
if (-not $folder) { $folder = (Get-Location).Path }

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Servidor local SHEKINAH iniciado com sucesso!" -ForegroundColor Green
Write-Host " Acesse no seu navegador: http://localhost:$port" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $path = $request.Url.LocalPath
        if ($path -eq '/' -or [string]::IsNullOrEmpty($path)) {
            $path = '/index.html'
        }

        $decodedPath = [System.Web.HttpUtility]::UrlDecode($path.TrimStart('/'))
        $filePath = Join-Path $folder $decodedPath.Replace('/', [System.IO.Path]::DirectorySeparatorChar)

        if (-not (Test-Path $filePath -PathType Leaf)) {
            $filePath = Join-Path $folder 'index.html'
        }

        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $mime = switch ($ext) {
                '.html' { 'text/html; charset=utf-8' }
                '.css'  { 'text/css; charset=utf-8' }
                '.js'   { 'application/javascript; charset=utf-8' }
                '.json' { 'application/json; charset=utf-8' }
                '.png'  { 'image/png' }
                '.jpg'  { 'image/jpeg' }
                '.jpeg' { 'image/jpeg' }
                '.svg'  { 'image/svg+xml' }
                '.ico'  { 'image/x-icon' }
                '.mp3'  { 'audio/mpeg' }
                default { 'application/octet-stream' }
            }
            $response.ContentType = $mime
            $response.AddHeader("Access-Control-Allow-Origin", "*")

            if ($request.HttpMethod -ne 'HEAD') {
                $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
                $response.ContentLength64 = $fileBytes.Length
                $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
            } else {
                $fileInfo = New-Object System.IO.FileInfo($filePath)
                $response.ContentLength64 = $fileInfo.Length
            }
        } else {
            $response.StatusCode = 404
        }
        $response.Close()
    }
} finally {
    $listener.Stop()
}
