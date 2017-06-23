###############################################################################################################################################################################
###                                                                                                           																###
###		.INFORMATIONS																																						###
###  	Script by Drago Petrovic -                                                                            																###
###     Technical Blog -               https://msb365.abstergo.ch                                               															###
###     GitHub Repository -            https://github.com/MSB365                                          	  																###
###     Webpage -                                                                  																							###
###     Xing:				   		   https://www.xing.com/profile/Drago_Petrovic																							###
###     LinkedIn:					   https://www.linkedin.com/in/drago-petrovic-86075730																					###
###																																											###
###		.VERSION																																							###
###     Version 1.0 - 02/02/2017                                                                              																###
###     Version 2.0 - 22/06/2017                                                                              																###
###     Revision -                                                                                            																###
###                                                                                                           																### 
###               v1.0 - Initial script										                                  																###
###               v2.0 - Exchange 2016 supported                                          																					###
###																																											###
###																																											###
###		.SYNOPSIS																																							###
###		DistributionGroupMemberReport.ps1																																	###
###																																											###
###		.DESCRIPTION																																						###
###		It Can Display all the Distribution Group and its members on a List or It can Export to a CSV file																	###
###																																											###
###		.PARAMETER																																							###
###																																											###
###																																											###
###		.EXAMPLE																																							###
###		.\MsCloudPsConnector.ps1																																			###
###																																											###
###		.NOTES																																								###
###		Ensure you update the script with your tenant name and username																										###
###		Your username is in the Exchange Online section for Get-Credential																									### 	
###		The tenant name is used in the Exchange Online section for Get-Credential																							###
###		The tenant name is used in the SharePoint Online section for SharePoint connection URL																				###
###                                                                                                           																###  	
###     .COPIRIGHT                                                            																								###
###		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 					###
###		to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 					###
###		and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:							###
###																																											###
###		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.										###
###																																											###
###		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 				###
###		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 		###
###		WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.			###
###                 																																						###
###                                                																															###
###     --- keep it simple, but significant ---                                                                                            									###
###                                                                                                           																###
###############################################################################################################################################################################



# Display options
Write-host "

Distribution Group Member Report
----------------------------

1.Display in Exchange Management Shell

2.Export to CSV File

3.Enter the Distribution Group name with Wild Card (Export)

4.Enter the Distribution Group name with Wild Card (Display)

Dynamic Distribution Group Member Report
----------------------------

5.Display in Exchange Management Shell

6.Export to CSV File

7.Enter the Dynamic Distribution Group name with Wild Card (Export)

8.Enter the Dynamic Group name with Wild Card (Display)"-ForeGround "Cyan"

Write-Host "keep it simple but significant!"-ForeGround "Magenta"



#----------------
# Script
#----------------

Write-Host "               "

$number = Read-Host "Choose The Task"
$output = @()
switch ($number) 
{

1 {

$AllDG = Get-DistributionGroup -resultsize unlimited
Foreach($dg in $allDg)
 {
$Members = Get-DistributionGroupMember $Dg.name -resultsize unlimited


if($members.count -eq 0)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }
else
{
Foreach($Member in $members)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $member.Alias
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }

}

  }

;Break}

2 {

$i = 0 

$CSVfile = Read-Host "Enter the Path of CSV file (Eg. C:\DG.csv)" 

$AllDG = Get-DistributionGroup -resultsize unlimited

Foreach($dg in $allDg)
{
$Members = Get-DistributionGroupMember $Dg.name -resultsize unlimited

if($members.count -eq 0)
{
$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.GroupType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

}
else
{
Foreach($Member in $members)
 {

$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $Member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $Member.Alias
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value $Member.RecipientType
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value $Member.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $Member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.GroupType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

 }
}
# update counters and write progress
$i++
Write-Progress -activity "Scanning Groups . . ." -status "Scanned: $i of $($allDg.Count)" -percentComplete (($i / $allDg.Count)  * 100)
$output | Export-csv -Path $CSVfile -NoTypeInformation

}

;Break}

3 {

$i = 0 

$CSVfile = Read-Host "Enter the Path of CSV file (Eg. C:\DG.csv)" 

$Dgname = Read-Host "Enter the DG name or Range (Eg. DGname , DG*,*DG)"

$AllDG = Get-DistributionGroup $Dgname -resultsize unlimited

Foreach($dg in $allDg)

{

$Members = Get-DistributionGroupMember $Dg.name -resultsize unlimited

if($members.count -eq 0)
{
$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.GroupType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

}
else
{
Foreach($Member in $members)
 {

$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $Member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $Member.Alias
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value $Member.RecipientType
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value $Member.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $Member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.GroupType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

 }
}
# update counters and write progress
$i++
Write-Progress -activity "Scanning Groups . . ." -status "Scanned: $i of $($allDg.Count)" -percentComplete (($i / $allDg.Count)  * 100)
$output | Export-csv -Path $CSVfile -NoTypeInformation

}

;Break}

4 {

$Dgname = Read-Host "Enter the DG name or Range (Eg. DGname , DG*,*DG)"

$AllDG = Get-DistributionGroup $Dgname -resultsize unlimited

Foreach($dg in $allDg)

 {

$Members = Get-DistributionGroupMember $Dg.name -resultsize unlimited

if($members.count -eq 0)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }
else
{
Foreach($Member in $members)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $member.Alias
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }

}

  }

;Break}

5 {

$AllDG = Get-DynamicDistributionGroup -resultsize unlimited

Foreach($dg in $allDg)

{

$Members = Get-Recipient -RecipientPreviewFilter $dg.RecipientFilter -resultsize unlimited

if($members.count -eq 0)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }
else
{
Foreach($Member in $members)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $member.Alias
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }

}

  }

;Break}

6 {
$i = 0 

$CSVfile = Read-Host "Enter the Path of CSV file (Eg. C:\DYDG.csv)" 

$AllDG = Get-DynamicDistributionGroup -resultsize unlimited

Foreach($dg in $allDg)

{

$Members = Get-Recipient -RecipientPreviewFilter $dg.RecipientFilter -resultsize unlimited

if($members.count -eq 0)
{
$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.RecipientType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

}
else
{
Foreach($Member in $members)
 {

$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $Member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $Member.Alias
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value $Member.RecipientType
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value $Member.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $Member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.RecipientType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

 }
}
# update counters and write progress
$i++
Write-Progress -activity "Scanning Groups . . ." -status "Scanned: $i of $($allDg.Count)" -percentComplete (($i / $allDg.Count)  * 100)
$output | Export-csv -Path $CSVfile -NoTypeInformation

}

;Break}

7 {
$i = 0 

$CSVfile = Read-Host "Enter the Path of CSV file (Eg. C:\DYDG.csv)" 

$Dgname = Read-Host "Enter the DG name or Range (Eg. DynmicDGname , Dy*,*Dy)"

$AllDG = Get-DynamicDistributionGroup $Dgname -resultsize unlimited

Foreach($dg in $allDg)

{

$Members = Get-Recipient -RecipientPreviewFilter $dg.RecipientFilter -resultsize unlimited

if($members.count -eq 0)
{
$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmptyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.RecipientType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

}
else
{
Foreach($Member in $members)
 {

$managers = $Dg | Select @{Name='DistributionGroupManagers';Expression={[string]::join(";", ($_.Managedby))}}

$userObj = New-Object PSObject

$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $Member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $Member.Alias
$userObj | Add-Member NoteProperty -Name "RecipientType" -Value $Member.RecipientType
$userObj | Add-Member NoteProperty -Name "Recipient OU" -Value $Member.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $Member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
$userObj | Add-Member NoteProperty -Name "Distribution Group Primary SMTP address" -Value $DG.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group Managers" -Value $managers.DistributionGroupManagers
$userObj | Add-Member NoteProperty -Name "Distribution Group OU" -Value $DG.OrganizationalUnit
$userObj | Add-Member NoteProperty -Name "Distribution Group Type" -Value $DG.RecipientType
$userObj | Add-Member NoteProperty -Name "Distribution Group Recipient Type" -Value $DG.RecipientType

$output += $UserObj  

 }
}
# update counters and write progress
$i++
Write-Progress -activity "Scanning Groups . . ." -status "Scanned: $i of $($allDg.Count)" -percentComplete (($i / $allDg.Count)  * 100)
$output | Export-csv -Path $CSVfile -NoTypeInformation

}

;Break}

8 {

$Dgname = Read-Host "Enter the Dynamic DG name or Range (Eg. DynamicDGname , DG*,*DG)"

$AllDG = Get-DynamicDistributionGroup $Dgname -resultsize unlimited

Foreach($dg in $allDg)

{

$Members = Get-Recipient -RecipientPreviewFilter $dg.RecipientFilter -resultsize unlimited

if($members.count -eq 0)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Alias" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value EmtpyGroup
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }
else
{
Foreach($Member in $members)
 {
$userObj = New-Object PSObject
$userObj | Add-Member NoteProperty -Name "DisplayName" -Value $member.Name
$userObj | Add-Member NoteProperty -Name "Alias" -Value $member.Alias
$userObj | Add-Member NoteProperty -Name "Primary SMTP address" -Value $member.PrimarySmtpAddress
$userObj | Add-Member NoteProperty -Name "Distribution Group" -Value $DG.Name
Write-Output $Userobj
 }

}

  }

;Break}

Default {Write-Host "No matches found , Enter Options 1 or 2" -ForeGround "red"}

}