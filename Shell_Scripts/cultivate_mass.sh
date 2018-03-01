

array=(10:41:7F 24:5B:A7 28:B2:BD 30:35:AD 34:08:BC 60:57:18 64:B0:A6 78:4F:43 78:7B:8A 8C:85:90 98:E0:D9 9C:F3:87 A4:5E:60 A8:66:7F AC:BC:32 B8:53:AC B8:81:98 D0:A6:37 E0:5F:45 F4:0F:24 6C:F3:73 B8:57:D8 5C:49:7D 9C:8C:6E C0:17:4D B4:3A:28 84:C0:EF A0:B4:A5 20:D3:90 7C:0B:C6 F0:5B:7B 94:51:03 18:E2:C2 20:13:E0 78:52:1A 14:32:D1 9C:E6:E7 48:44:F7 28:98:7B BC:76:5E 84:11:9E B8:6C:E8 D8:90:E8 38:94:96 F4:C2:48 08:08:C2 2C:40:53 14:56:8E 78:00:9E D4:E8:B2 24:4B:81)

choice=$((RANDOM%15+0))




oneRandomByte ()
{
	cat /dev/urandom | tr -dc 'A-F0-9' |fold -w2 | head -1
}


result=${array[$choice]}:$(oneRandomByte):$(oneRandomByte):$(oneRandomByte)


macchanger -m $result wlan0


unset array
unset choice
unset result
unset oneRandomByte
