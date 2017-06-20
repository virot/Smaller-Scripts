function Convert-Int2Complement{
<#
.SYNOPSIS
Conversion using two Complement

.DESCRIPTION
Uses two's complement to convert from negative int to positive uint and vise versa.

.PARAMETER Integer
Input to the conversation.

.INPUTS
Int16, Int32, Int64, uInt16, uInt32, uInt64

.OUTPUTS
None.

.EXAMPLE
C:\PS> ConvertTo-Unsigned -Integer ([int]-2147483640)
2147483656

.EXAMPLE
C:\PS> ConvertTo-Unsigned -Integer ([int16]-32768)
32768

.EXAMPLE
C:\PS> ConvertTo-Unsigned -Integer ([int16]-32767)
32769


.LINK
My Blog: http://virot.eu
Blog Entry: http://virot.eu/wordpress/converting-from-twos-complement-using-powershell
Github: https://github.com/virot/Smaller-Scripts/tree/master/Convert-Int2Complement
.NOTES
Author:	Oscar Virot - virot@virot.com
Filename: Convert-Int2Complement.ps1
#>
param
  (
    [Parameter(Mandatory=$true)]
    [ValidateScript({@('int16','int32','int64','uint16','uint32','uint64') -contains $_.GetType().Name})]
    [object]
    $Integer
  )
  Process
  {
    switch ($Integer.GetType().Name)
    {
      'int16' {return [System.BitConverter]::TouInt16([bitconverter]::GetBytes($integer),0)}
      'int32' {return [System.BitConverter]::TouInt32([bitconverter]::GetBytes($integer),0)}
      'int64' {return [System.BitConverter]::TouInt64([bitconverter]::GetBytes($integer),0)}
      'uint16' {return [System.BitConverter]::ToInt16([bitconverter]::GetBytes($integer),0)}
      'uint32' {return [System.BitConverter]::ToInt32([bitconverter]::GetBytes($integer),0)}
      'uint64' {return [System.BitConverter]::ToInt64([bitconverter]::GetBytes($integer),0)}
    }
  }
}