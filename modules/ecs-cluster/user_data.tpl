<powershell>

##reduce the amount of real time scan cpu, needs more work!
Add-MpPreference -ExclusionPath “C:\ProgramData\docker"
Set-MpPreference -DisableRealtimeMonitoring $True
Set-MpPreference -DisableBlockAtFirstSeen $True
Set-MpPreference -DisableArchiveScanning $True

## attempt to correct an intermittently starting Docker service
stop-service docker

########## Below are AWS ECS required bits ########

## The string 'windows' should be replaced with your cluster name
$ecsExeDir = "$env:ProgramFiles\Amazon\ECS"
# Set agent env variables for the Machine context (durable)
[Environment]::SetEnvironmentVariable("ECS_CLUSTER", "${cluster_name}", "Machine")
[Environment]::SetEnvironmentVariable("ECS_ENABLE_TASK_IAM_ROLE", "true", "Machine")
$agentVersion = "latest"
$agentZipUri = "https://s3.amazonaws.com/amazon-ecs-agent/ecs-agent-windows-$agentVersion.zip"
$zipFile = "$env:TEMP\ecs-agent.zip"
Invoke-RestMethod -OutFile $zipFile -Uri $agentZipUri

# Put the executables in the executable directory.
Expand-Archive -Path $zipFile -DestinationPath $ecsExeDir -Force


start-service docker
start-sleep -s 5

## Start the agent script in the background.
$jobname = "ECS-Agent-Init"
$script =  "cd '$ecsExeDir'; .\amazon-ecs-agent.ps1"
$repeat = (New-TimeSpan -Minutes 1)

$jobpath = $env:LOCALAPPDATA + "\Microsoft\Windows\PowerShell\ScheduledJobs\$jobname\ScheduledJobDefinition.xml"
if($(Test-Path -Path $jobpath)) {
  echo "Job definition already present"
  exit 0
}

$scriptblock = [scriptblock]::Create("$script")
$trigger = New-JobTrigger -At (Get-Date).Date -RepeatIndefinitely -RepetitionInterval $repeat -Once
$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
Register-ScheduledJob -Name $jobname -ScriptBlock $scriptblock -Trigger $trigger -ScheduledJobOption $options -RunNow
Add-JobTrigger -Name $jobname -Trigger (New-JobTrigger -AtStartup -RandomDelay 00:1:00)
</powershell>
<persist>true</persist>
