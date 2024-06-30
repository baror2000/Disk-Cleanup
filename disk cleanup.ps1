function Disk_Cleanup {
    Show-ListDisk
    Refresh_ListDisk
    $disk_num = Read-Host "Please select your target disk number"
    $letter = Read-Host "Please choose new drive letter"
    $name = Read-Host "Please choose new drive name"

    $diskpartScript = @"
select disk $disk_num
clean
create partition primary
active
format fs=ntfs label="$name" quick
assign letter=$letter
"@

    echo $diskpartScript | diskpart
}

function Show-ListDisk {
    $listDiskScript = "list disk"
    $output = echo $listDiskScript | diskpart | Out-String
    Write-Output $output
}

function Refresh_ListDisk {
    while ($true) {
        $refresh = Read-Host "Please choose Refresh (R) or Continue (C)"
        if ($refresh -eq "R") {
            Show-ListDisk
        } elseif ($refresh -eq "C") {
            break
        } else {
            Write-Host "Incorrect option selected. Please choose Refresh (R) or Continue (C)."
        }
    }
}

function again {
    while ($true) {
        $again = Read-Host "Finished formatting the drive. Would you like to run again? (Y/N)"
        if ($again -eq "Y") {
            Disk_Cleanup
        } elseif ($again -eq "N") {
            exit
        } else {
            Write-Host "Incorrect option selected"
        }
    }
}

Disk_Cleanup
again
