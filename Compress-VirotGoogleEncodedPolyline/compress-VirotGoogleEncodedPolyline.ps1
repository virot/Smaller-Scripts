Function compress-VirotGoogleEncodedPolyline
{
[CmdletBinding(SupportsShouldProcess=$false)]
  param(
    [Parameter(Mandatory=$true)]
    [string[]]
    $coordinates
  )
  Process
  {
    $cordenc=''
    $lastlat = 0
    $lastlong = 0
    ForEach ($Coordinate in ($Coordinates | ? {$_ -ne ''}))
    {
      $lat, $long = $Coordinate -split ','|%{[int32]([double]$_ * 100000)}
      Write-Verbose "Latitude : $lat, Longitude $long"
      [int]$lat = $lat - $lastlat
      [int]$long = $long - $lastlong
      Write-Debug "Change In Latitude : $lat, Longitude $long"
      $latShifted = $lat -shl 1
      $longShifted = $long -shl 1
      if ([double]$lat -lt 0){$latShifted = $latShifted -bxor [uint32]::MaxValue}
      if ([double]$long -lt 0){$longShifted = $longShifted -bxor [uint32]::MaxValue}
      Write-Debug "Longitude-Step5 $([convert]::tostring($longShifted,2))"
      Write-Debug "Latitude-Step5 $([convert]::tostring($latShifted,2))"
      $longShunks = [convert]::tostring($longShifted,2).padleft(35,'0') -split '(.....)' |? {$_ -ne ''}
      $latShunks = [convert]::tostring($latShifted,2).padleft(35,'0') -split '(.....)' |? {$_ -ne ''}
      if($long -ne 0)
      {
        While ($longShunks[0] -eq '00000') {$longShunks = $longShunks[1..($longShunks.Count-1)]}
      }
      else
      {
        $longShunks = @('00000')
      }
      if($lat -ne 0)
      {
        While ($latShunks[0] -eq '00000') {$latShunks = $latShunks[1..($latShunks.Count-1)]}
      }
      else
      {
        $latShunks = @('00000')
      }
      Write-Debug "Longitude-Step6 $($longShunks -join " ")"
      Write-Debug "Latitude-Step6 $($latShunks -join " ")"
      [array]::Reverse($longShunks)
      [array]::Reverse($latShunks)
      Write-Debug "Longitude-Step7 $($longShunks -join " ")"
      Write-Debug "Latitude-Step7 $($latShunks -join " ")"
      $longShunksUint32 = [array]($longShunks |%{[convert]::ToUInt32($_,2) -bor 0x20})
      $latShunksUint32 = [array]($latShunks |%{[convert]::ToUInt32($_,2) -bor 0x20})
      Write-Debug "Longitude-Step8 $($longShunksUint32 -join " ")"
      Write-Debug "Latitude-Step8 $($latShunksUint32 -join " ")"
      $longShunksUint32[-1] = $longShunksUint32[-1] -band 0xFFDF
      $latShunksUint32[-1] = $latShunksUint32[-1] -band 0xFFDF
      Write-Debug "Longitude-Step9 $($longShunksUint32 -join " ")"
      Write-Debug "Latitude-Step9 $($latShunksUint32 -join " ")"
      $cordenc += ($latShunksUint32 | % {[char](63+$_)}) -join ''
      $cordenc += ($longShunksUint32 | % {[char](63+$_)}) -join ''
      $lastlat, $lastlong = $Coordinate -split ','|%{[int32]([double]$_ * 100000)}
    }
    return $cordenc
  }
}