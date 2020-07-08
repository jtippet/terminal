Param(
  [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
  [string]$Path,
  [string]$Destination,
  [int[]]$Altforms = (16, 20, 24, 30, 32, 36, 40, 48, 60, 64, 72, 80, 96, 256),
  [switch]$Unplated = $true,
  [float[]]$Scales = (1.0, 1.25, 1.5, 2.0, 4.0),
  [string]$HighContrastPath = ""
)

$assetTypes = @(
  [pscustomobject]@{Name="LargeTile"; W=310; H=310; IconSize=96}
  [pscustomobject]@{Name="LockScreenLogo"; W=24; H=24; IconSize=24}
  [pscustomobject]@{Name="SmallTile"; W=71; H=71; IconSize=36}
  [pscustomobject]@{Name="SplashScreen"; W=620; H=300; IconSize=96}
  [pscustomobject]@{Name="Square44x44Logo"; W=44; H=44; IconSize=32}
  [pscustomobject]@{Name="Square150x150Logo"; W=150; H=150; IconSize=48}
  [pscustomobject]@{Name="StoreLogo"; W=50; H=50; IconSize=36}
  [pscustomobject]@{Name="Wide310x150Logo"; W=310; H=150; IconSize=48}
)

function CeilToEven ([int]$i) { if ($i % 2 -eq 0) { [int]($i) } else { [int]($i + 1) } }

$inflatedAssetSizes = $assetTypes | ForEach-Object {
  $as = $_;
  $scales | ForEach-Object {
    [pscustomobject]@{
      Name = $as.Name + ".scale-$($_*100)"
      W = [math]::Round($as.W * $_, [System.MidpointRounding]::ToPositiveInfinity)
      H = [math]::Round($as.H * $_, [System.MidpointRounding]::ToPositiveInfinity)
      IconSize = CeilToEven ($as.IconSize * $_)
    }
  }
}

$allAssetSizes = $inflatedAssetSizes + ($Altforms | ForEach-Object {
    [pscustomobject]@{
      Name = "Square44x44Logo.targetsize-${_}"
      W = [int]$_
      H = [int]$_
      IconSize = [int]$_
    }
    If ($Unplated) {
      [pscustomobject]@{
        Name = "Square44x44Logo.targetsize-${_}_altform-unplated"
        W = [int]$_
        H = [int]$_
        IconSize = [int]$_
      }
    }
  })

# Cross with all the different high contrast modes
$allAssetSizes = $allAssetSizes | ForEach-Object {
    $asset = $_
    ("standard", "black", "white") | ForEach-Object {
        $contrast = $_
        $name = $asset.Name
        If ($contrast -Ne "standard") {
            If ($HighContrastPath -Eq "") {
                return
            }
            $name += "_contrast-" + $contrast
        }
        [pscustomobject]@{
            Name = $name
            W = $asset.W
            H = $asset.H
            IconSize = $asset.IconSize
            Contrast = $_
      }
    }
}

$allSizes = $allAssetSizes.IconSize | Group-Object | Select-Object -Expand Name

$TranslatedSVGPath = & wsl wslpath -u ((Get-Item $Path -ErrorAction:Stop).FullName -Replace "\\","/")
$TranslatedSVGHCPath = $null
If ($HighContrastPath -Ne "") {
    $TranslatedSVGHCPath = & wsl wslpath -u ((Get-Item $HighContrastPath -ErrorAction:Stop).FullName -Replace "\\","/")
}
& wsl which inkscape | Out-Null
If ($LASTEXITCODE -Ne 0) { throw "Inkscape is not installed in WSL" }
& wsl which convert | Out-Null
If ($LASTEXITCODE -Ne 0) { throw "imagemagick is not installed in WSL" }

If (-Not [string]::IsNullOrEmpty($Destination)) {
  New-Item -Type Directory $Destination -EA:Ignore
  $TranslatedOutDir = & wsl wslpath -u ((Get-Item $Destination -EA:Stop).FullName -Replace "\\","/")
} Else {
  $TranslatedOutDir = "."
}

# Generate the base icons
$allSizes | ForEach-Object -Parallel {
  $sz = $_;
  wsl inkscape -z -e "$($using:TranslatedOutDir)/zbase.standard.$($sz).png" -w $sz -h $sz $using:TranslatedSVGPath 

  If ($using:TranslatedSVGHCPath -Ne $null) {
    wsl inkscape -z -e "$($using:TranslatedOutDir)/zbase.black.$($sz).png" -w $sz -h $sz $using:TranslatedSVGHCPath 
    wsl convert "$($using:TranslatedOutDir)/zbase.black.$($sz).png" -channel RGB -negate "$($using:TranslatedOutDir)/zbase.white.$($sz).png"
  }
}

# Once the base icons are done, splat them into the middles of larger canvases.
$allAssetSizes | ForEach-Object -Parallel {
  $asset = $_
  If ($asset.W -Eq $asset.H -And $asset.IconSize -eq $asset.W) {
    Write-Host "Copying base icon for size $($asset.IconSize), contrast $($asset.Contrast) to $($asset.Name)"
    Copy-Item "${using:Destination}\zbase.$($asset.Contrast).$($asset.IconSize).png" "${using:Destination}\$($asset.Name).png" -Force
  } Else {
    wsl convert "$($using:TranslatedOutDir)/zbase.$($asset.Contrast).$($asset.IconSize).png" -gravity center -background transparent -extent "$($asset.W)x$($asset.H)" "$($using:TranslatedOutDir)/$($asset.Name).png"
  }
}
