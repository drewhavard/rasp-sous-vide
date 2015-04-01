#!/usr/bin/perl
 
my $dir = '/home/sousvide';
my $is_celsius = 0; #set to 1 if using Celsius
my $relay_pin = 17; #which GPIO pin the relay is connected to
my $target_temp_filename = '/home/sousvide/targettemp.txt';
 
$modules = `cat /proc/modules`;
if ($modules =~ /w1_therm/ && $modules =~ /w1_gpio/)
{
        #modules installed
}
else
{
        $gpio = `sudo modprobe w1-gpio`;
        $therm = `sudo modprobe w1-therm`;
}

#print "Got this far\n";


#The following lines allow this to run as a daemon
#Be sure to call this script from rc.local
close(STDIN);
close(STDOU);
close(STDERR);
exit if (fork());
exit if (fork());

system("echo 17 > /sys/class/gpio/export");
system("echo out > /sys/class/gpio/gpio17/direction");

$loops = 0;
$targetTemp = 0;

while(1){
$output = "";
$attempts = 0;
$temp = 100;
open my $fh, "<", $target_temp_filename;
	while ($output !~ /YES/g && $attempts < 5)
	{
	        $output = `sudo cat /sys/bus/w1/devices/28-*/w1_slave 2>&1`;
	        if($output =~ /No such file or directory/)
	        {
	                #print "Could not find DS18B20\n";
	                last;
	        }
	        elsif($output !~ /NO/g)
	        {
	                $output =~ /t=(\d+)/i;
	                $temp = ($is_celsius) ? ($1 / 1000) : ($1 / 1000) * 9/5 + 32;
	                $rrd = `/usr/bin/rrdtool update $dir/watertemp.rrd N:$temp`;
	        }
	 
	        $attempts++;
	}
$loops = $loops + 1;
if($loops >1) #Creates graphs every other loop
{
	system("bash '$dir'/create_graphs.sh");
	$loops = 0;
}
while( my $line = <$fh>)  
{   
	$targetTemp = $line;
	#print ("Target temp is: '$targetTemp'\n");
	#print ("Current temp is: '$temp'\n");
	if($targetTemp > $temp)
	{
		#print("Turning on solid state relay\n");
		system("echo 1 > /sys/class/gpio/gpio'$relay_pin'/value");
	}
	else
	{
		#print("Turning off solid state relay\n");
		system("echo 0 > /sys/class/gpio/gpio'$relay_pin'/value");
	}
	#print $line;    
	#last if $. == 2; #Allows exit if a certain line number reached
}
close $fh;

#system("echo 1 > /sys/class/gpio/gpio'$relay_pin'/value");
select(undef, undef, undef, .75);
#system("echo 0 > /sys/class/gpio/gpio'$relay_pin'/value");
#print "Water Temp: $temp\n";
}
