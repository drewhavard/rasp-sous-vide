print "\n [+]----------------------------------------[+]";
print "\n  |    GPIO Control by using perl on bash    |";
print "\n  |      Test on Raspbian Wheezy [RPi]       |";
print "\n  |                                          |";
print "\n  |   Created by : AssazziN                  |";
print "\n  |   Version 1: 11 Mar 2013                 |";
print "\n [+]----------------------------------------[+]\n";
 
print "\n >> type h|help for help\n";
do {
        print " >> ";
        chomp($input=<STDIN>);
        if ($input eq 'h' or $input eq 'help') { help(); }
 
        elsif ($input=~/^export (\d{1,2})$/) {
                system("echo \"$1\" > /sys/class/gpio/export");
        }
 
        elsif ($input=~/^direction (\d{1,2}) (out|in)$/) {
                system("echo \"$2\" > /sys/class/gpio/gpio".$1."/direction");
        }
 
        elsif ($input=~/^value (\d{1,2}) (1|0)$/) {
                system("echo \"$2\" > /sys/class/gpio/gpio".$1."/value");
        }
 
        elsif ($input=~/^unexport (\d{1,2})$/) {
                system("echo \"$1\" > /sys/class/gpio/unexport");
        }
 
        elsif ($input=~/status/i) {
                @pin=();
                $pin=`find /sys/class/gpio/ gpio*`;
                while ($pin=~/sys\/class\/gpio\/gpio(\d{1,2})/g) { push(@pin,$1); }
                print " All pins that useabled : @pin\n";
        }
 
        elsif ($input eq 'q' or $input eq 'quit' or $input eq 'exit') {}
        else { print " $input : command not found\n"; }
} while ($input ne 'q' and $input ne 'quit' and $input ne 'exit');
 
 
 
sub help {
        print "\n ** This script requirement ROOT ***\n";
        print " > export [GPIO PIN]                 set gpio pin to useable\n";
        print " > direction [GPIO PIN] [out|in]     set gpio pin direction\n";
        print " > value [GPIO PIN] [1|0]            set gpio pin value\n";
        print " > unexport [GPIO PIN]               set gpio pin to unuseable\n";
        print " > status                            check status of all pin\n";
        print " > q quit exit                       exit script\n\n";
}
