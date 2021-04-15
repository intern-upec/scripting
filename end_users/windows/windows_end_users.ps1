Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
$ipV4 = Test-Connection -ComputerName (hostname) -Count 1  | Select -ExpandProperty IPV4Address;
$ip = $ipV4.IPAddressToString;
Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value  $ip"        firstname-lastname-i";
Add-Content -Path C:\Windows\System32\drivers\etc\hosts -Value  "192.168.1.1        puppetmaster.i";
$hostname = hostname;
Rename-Computer -computername $hostname -newname "firstname-lastname-i";
New-NetFirewallRule -DisplayName "Allow puppet Agent to Master connection in port 8140" -Direction Outbound -LocalPort 8140 -Protocol TCP -Action Allow;
echo Y | choco install --ignore-checksums --force puppet-agent;
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User");
puppet.bat config set certname "firstname-lastname-i";
puppet.bat config set server "puppetmaster.i";
restart-computer