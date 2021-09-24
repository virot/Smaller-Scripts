Function ConvertTo-VirotEventObject
{
<#
.SYNOPSIS
Powershell cmdlet to convert Event format from Get-WinEvent to Object

.DESCRIPTION
This will take input from Get-WinEvent and transform it into Powershell Object format for easier manipulation

.PARAMETER Event
Input event

.OUTPUTS
Custom object

.EXAMPLE
Get-WinEvent -LogName Security -MaxEvents 2|ConvertTo-VirotEventObject
TimeCreated       : 2016-09-22 00:53:21
EventID           : 4735
TargetUserName    : Administrators
TargetDomainName  : Builtin
TargetSid         : S-1-5-32-544
SubjectUserSid    : S-1-5-18
SubjectUserName   : TEST$
SubjectDomainName : VIROT
SubjectLogonId    : 0x3e7
PrivilegeList     : -
SamAccountName    : -
SidHistory        : -

TimeCreated      : 2016-09-22 00:53:21
EventID          : 4634
TargetUserSid    : S-1-5-18
TargetUserName   : TEST$
TargetDomainName : VIROT
TargetLogonId    : 0x17d4aa09
LogonType        : 3

.EXAMPLE
ConvertTo-VirotEventObject -Event (Get-WinEvent -LogName Application -MaxEvents 1)


.LINK
My Blog: http://virot.eu
Blog Entry: http://virot.eu/
Script center: https://gallery.technet.microsoft.com/scriptcenter/Cmdlet-to-convert-from-0b60a1e8

.NOTES
Author:	Oscar Virot - virot@virot.com
Filename: ConvertTo-VirotEventObject.ps1
Version: 2016-09-25

#>
[CmdletBinding(SupportsShouldProcess=$False)]
  param (
    [parameter(ValueFromPipeline,Mandatory=$True)]
    [System.Diagnostics.Eventing.Reader.EventRecord]
    $Event
  )

  Begin
  {
    if ($PSVersionTable.PSVersion.Major -ge 5)
    {
      $Namespace = [System.Xml.XmlNamespaceManager]::new([System.Xml.NameTable]::new())
      $Namespace.AddNamespace('Events','http://schemas.microsoft.com/win/2004/08/events/event')
    }
    $EventFormating = @{}
  }
  Process
  {
    $Xmlevent = [Xml]$Event.ToXml()
    if ($EventFormating.Keys -notcontains $event.id)
    {
      Write-Verbose "`$EventFormating count $([array]$EventFormating.Count)"
      Write-Verbose "Building XML to Object formating map"
      $tempFormating = @{l='TimeCreated';e={Get-Date $Xmlevent.event.system.timecreated.systemtime}},
        @{l='EventID';e={$Xmlevent.Event.system.EventID}}

      if ($PSVersionTable.PSVersion.Major -ge 5)
      {
        ForEach($Property in ($Xmlevent.Event.Eventdata.data.name))
        {
          $tempFormating += Invoke-Expression "@{l='$Property';e={`$Xmlevent.SelectSingleNode('//Events:Data[@Name=""$($Property)""]',`$Namespace).'#text'}}"

        }
        $EventFormating[$event.id] = $tempFormating
      }
      else
      {
        For($Property = 0; $Property -lt ($Xmlevent.Event.Eventdata.data.name).count; $Property++)
        {
          $tempFormating += Invoke-Expression  "@{l='$($Xmlevent.Event.EventData.Data.'Name'[$Property])';e={`$Xmlevent.Event.EventData.Data.'#text'[$($Property)]}}"
        }
        $EventFormating[$event.id] = $tempFormating
      }
    }
#Return the processed Eventdata
    return $True |Select $EventFormating[$event.id]
  }
  End
  {
    Write-Verbose "`$EventFormating count at the end was $([array]$EventFormating.Count)"
  }
}