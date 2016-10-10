<#
*** System level access is needed to run ***
This script will return the SID of the system and the RID that will be given to the next account created on the system.
#>

# Gets Registry keys and data
$rid_key = reg query "hklm\sam\sam\domains\account" /v F
$sid_key = reg query "hklm\sam\sam\domains\account" /v V

# Converts from system.object to string
$rid_data = [string]$rid_key
$sid_data = [string]$sid_key

# Drops all characters from the registry data except the 4-byte hex number at offset 0x48
$rid_data = $rid_data.substring(211,8)

# Drops all characters from the registry data execpt the last 12-bytes of the value
$sid_data = $sid_data.substring(587,24)

# Breaks the SID data in to 4-byte chunks
$sid_data_1 = $sid_data.substring(0,8)
$sid_data_2 = $sid_data.substring(8,8)
$sid_data_3 = $sid_data.substring(16,8)

# Reverse the 8-byte hex due to Little Endian format
$rid_data_reverse = $rid_data.substring(6,2) + $rid_data.substring(4,2) + $rid_data.substring(2,2) + $rid_data.substring(0, 2)
$sid_data_1_reverse = $sid_data_1.substring(6,2) + $sid_data_1.substring(4,2) + $sid_data_1.substring(2,2) + $sid_data_1.substring(0, 2)
$sid_data_2_reverse = $sid_data_2.substring(6,2) + $sid_data_2.substring(4,2) + $sid_data_2.substring(2,2) + $sid_data_2.substring(0, 2)
$sid_data_3_reverse = $sid_data_3.substring(6,2) + $sid_data_3.substring(4,2) + $sid_data_3.substring(2,2) + $sid_data_3.substring(0, 2)

# Convert Hex to decimal
# https://community.spiceworks.com/topic/541931-powershell-problem-converting-hex-to-dec
$next_rid = [Convert]::ToInt32($rid_data_reverse, 16)
$sid_1 = [Convert]::ToInt64($sid_data_1_reverse, 16)
$sid_2 = [Convert]::ToInt64($sid_data_2_reverse, 16)
$sid_3 = [Convert]::ToInt64($sid_data_3_reverse, 16)

echo "The SID is S-1-5-21-$sid_1-$sid_2-$sid_3"
echo ""
echo "The next RID is $next_rid"
