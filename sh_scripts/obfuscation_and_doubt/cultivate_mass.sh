

array=(08:08:C2 10:41:7F 14:32:D1 14:56:8E 18:65:90 18:E2:C2 20:13:E0 20:C9:D0 20:D3:90 24:4B:81 24:5B:A7 28:98:7B 28:B2:BD 28:CF:E9 2C:40:53 2C:F0:EE 30:35:AD 34:08:BC 34:36:3B 38:94:96 38:CA:DA 3C:15:C2 48:44:F7 50:6A:03 54:33:CB 5C:49:7D 5C:51:4F 60:57:18 64:B0:A6 6C:40:08 6C:F3:73 70:56:81 70:F0:87 78:00:9E 78:31:C1 78:4F:43 78:52:1A 78:7B:8A 7C:0B:C6 84:11:9E 84:C0:EF 8C:85:90 94:51:03 98:01:A7 98:E0:D9 9C:8C:6E 9C:E6:E7 9C:F3:87 A0:B4:A5 A4:5E:60 A8:66:7F AC:BC:32 B0:70:2D B4:3A:28 B4:AE:2B B8:08:CF B8:53:AC B8:57:D8 B8:6C:E8 B8:81:98 BC:54:36 BC:6C:21 BC:76:5E C0:17:4D D0:7E:35 D0:A6:37 D4:DC:CD D4:E8:B2 D8:90:E8 E0:5F:45 E4:F8:9C F0:5B:7B F0:D5:BF F4:0F:24 F4:C2:48)

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
