##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
#########                                                                           ##########
#########                                                                           ##########
#########                                                                           ##########
#########                                                                           ##########
#########        brettlib.tcl                                                       ##########
#########        ************                                                       ##########
set              revdate 4/21/2001;                                                 ##########
set              rev 1.7;                                                           ##########
#########        - PP (pretty print)                                                ##########
#########        - time_stamp                                                       ##########
#########        - print_counters                                                   ##########
#########        - lputs                                                            ##########
#########        - startlog                                                         ##########
#########        - stoplog                                                          ##########
#########        - dputs                                                            ##########
#########        - getcounters                                                      ##########
#########        - getrev                                                           ##########
#########        - getrevdate                                                       ##########
#########        - decode                                                           ##########
#########        - isodd                                                            ##########
#########        - gapnano_fromload_forfast-e                                       ##########
#########        - vpivci                                                           ##########
#########        - round                                                            ##########
#########        - trigger                                                          ##########
#########        - vfd                                                              ##########
#########        - whereami                                                         ##########
#########        - errordumper                                                      ##########
#########        - printfile                                                        ##########
#########        - startlog                                                         ##########
#########        - isnumeric                                                        ##########
#########        - numerize                                                         ##########
#########        - leftright                                                        ##########
#########        - addonetocrazystring                                              ##########
#########        - howmanyzeroes                                                    ##########
#########        - dottedquad                                                       ##########
#########        - sixmac                                                           ##########
#########        - gap_nanoseconds                                                  ##########
#########        - gap_nano_from_bits                                               ##########
#########        - round                                                            ##########
#########        - gap_bits                                                         ##########
#########        - GAP                                                              ##########
#########        - PPS                                                              ##########
#########                                                                           ##########
#########                                                                           ##########
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################
##############################################################################################

##########################################################################################
# PP ( Pretty Print ) I can't explain it
##########################################################################################
proc PP { totlen startpos { wall | }  data { repeater "no" } } {
set totlen [expr $totlen-1]
set underline_len [expr $totlen-1]
lputs -nonewline $wall
if { $repeater == "repeat" } {
for { set i 0 } { $i < $underline_len } { incr i } {
lputs -nonewline $data
}
} else {
set format_len [expr $totlen - $startpos ]
set startpos [expr $startpos -1]
lputs -nonewline [format %$startpos\s " "]
lputs -nonewline [format %-$format_len\s $data]
}
lputs $wall
}


##########################################################################################
# timestamp: returns a timestamp
##########################################################################################
proc time_stamp {} {
set i [clock format [clock seconds] -format %D]
set j [clock format [clock seconds] -format %T]
set k "$i, $j"
return $k
}

##########################################################################################
# print counters: prints out scriptcenter counters
##########################################################################################
proc print_counters { h s p count } {
set counterfield { RcvPkt TmtPkt Collision RcvTrig RcvByte CRC Align Oversize Undersize RcvPktRate TmtPktRate CRCRate OversizeRate UndersizeRate CollisionRate AlignRate RcvTrigRate RcvByteRate RxStack TxStack ArpReplyRcv ArpReqSent PingReplySent PingReqSent PingReqRcv }
puts "$h/$s/$p"
puts "--------"
puts "TX Packets    : [lindex $count [lsearch $counterfield TmtPkt]]"
puts "RX Packets    : [lindex $count [lsearch $counterfield RcvPkt]]"
puts "RX Triggers   : [lindex $count [lsearch $counterfield RcvTrig]]"
#puts "Lost Packets  : [expr $TmtPkt - $RcvPkt]"
#puts "Lost Triggers : [expr $TmtPkt - $RcvTrig]"
puts "CRC Errors    : [lindex $count [lsearch $counterfield CRC]]"
puts "TX Rate (P/s) : [lindex $count [lsearch $counterfield TmtPktRate]]"
}

##########################################################################################
# lputs: logs to a file LOG_FILE_HANDLE if LOG_FLAG is non-zero AND always does a regular puts
##########################################################################################
proc lputs { i { k "" } } {
if { $i == "-nonewline" } {
    puts -nonewline $k
if { $::LOG_FLAG } {
    puts -nonewline $::LOG_FILE_HANDLE $k
}
} else {
    puts $i
if { $::LOG_FLAG } {
    puts $::LOG_FILE_HANDLE $i
}
}
}

##########################################################################################
# stoplog: closes a filehandle
##########################################################################################
proc stoplog { fh } {
close $fh
}


##########################################################################################
# dputs: only prints if DEBUG_FLAG is set to non-zero
##########################################################################################
proc dputs { i { k "" } } {
if { $::DEBUG_FLAG } {
if { $i == "-nonewline" } {
    lputs -nonewline $k
} else {
    lputs $i
}
}
}

##########################################################################################
# getcounters
# --------------
# purpose: to print out counters for 2 slots
# paramaters: the slots
# returns: nothing, but prints out the counters in a nice format
# usage: getcounters 0 1
##########################################################################################
proc getcounters { $s $s2 } {
LIBCMD HGSetGroup ""
LIBCMD HGAddtoGroup 0 $s 0
LIBCMD HGAddtoGroup 0 $s2 0
struct_new cs HTCountStructure*2
LIBCMD HGGetCounters cs

puts -nonewline "[format %25s Card][format %3d [expr $s + 1]]"
puts "[format %9s Card][format %3d [expr $s2 +1]]"
puts "----------------------------------------"
puts "Tx Packets    [format %14d $cs(0.TmtPkt)]| [format %10d $cs(1.TmtPkt)]"
puts "Rx Packets    [format %14d $cs(0.RcvPkt)]| [format %10d $cs(1.RcvPkt)]"
puts "Collisions    [format %14d $cs(0.Collision)]| [format %10d $cs(1.Collision)]"
puts "Recvd Trigger [format %14d $cs(0.RcvTrig)]| [format %10d $cs(1.RcvTrig)]"
puts "CRC Errors    [format %14d $cs(0.CRC)]| [format %10d $cs(1.CRC)]"
puts "----------------------------------------"
puts "Oversize      [format %14d $cs(0.Oversize)]| [format %10d $cs(1.Oversize)]"
puts "Undersize     [format %14d $cs(0.Undersize)]| [format %10d $cs(1.Undersize)]"
puts "----------------------------------------"
}

##########################################################################################
# getrev
# --------------
# purpose: to return the rev of a program
# paramaters: none
# returns: the rev
# usage: puts [getrev]
##########################################################################################
proc getrev {} { return $::rev     }

##########################################################################################
# getrevdate
# --------------
# purpose: to return the revdate of a program
# paramaters: none
# returns: the revdate
# usage: puts [getrevdate]
##########################################################################################
proc getrevdate {} { return $::revdate }

##########################################################################################
# decode
# --------------
# purpose: to printfile the MAC and IP and TOS decode of some hex data
# paramaters: the pkt, as read from a file. NOTE: Format must be EX_ReturnCapturePacket
# returns: nix
# usage: decode $pkt
##########################################################################################
proc decode { pkt } {

   printfile  -nonewline "DM:"
   for { set i 0 } { $i < 6 } { incr i } {
      set j [lindex $pkt $i]
      printfile  -nonewline "$j"
      if { [expr $i+1] < 6 } { printfile  -nonewline "." }
   }

   #display source MAC
   printfile  -nonewline " ! SM:"
   for { set i 6 } { $i < 12 } { incr i } {
      set j [lindex $pkt $i]
      printfile  -nonewline "$j"
      if { [expr $i+1] < 12} { printfile  -nonewline "." }
   }
   #display TOS
#   printfile  -nonewline "TOS:"
#   printfile  -nonewline [lindex $pkt 15]

   #display source IP add
   printfile  -nonewline " ! SI:"
   for { set i 26 } { $i < 30 } { incr i } {
      #scan [lindex $pkt $i]  %x j
      set j [lindex $pkt $i]
      printfile  -nonewline "$j"
      if { [expr $i+1] < 30 } { printfile  -nonewline "." }
   }

   #display dest IP add
   printfile  -nonewline " ! DI:"
   for { set i 30 } { $i < 34 } { incr i } {
      set j [lindex $pkt $i]
      #scan [lindex $pkt $i]  %x j
      printfile  -nonewline "$j"
      if { [expr $i+1] < 34 } { printfile  -nonewline "." }
   }
   printfile  ""
}

##########################################################################################
# isodd
# --------------
# purpose: tell you if the number if odd or even
# paramaters: the number
# returns: 1 if odd, 0 if even
# usage: puts [isodd 5]
##########################################################################################
proc isodd { i } {
    if { [expr $i / 2] < [expr $i.0 / 2.0] } { return 1 }
    return 0
}


###########################################################################################################################################################################################
# Brett-Documenation
#
# proc gapnano_fromload_forfast-e
# -------------------------------
# purpose: find the gap for fast-E in nanoseconds given the percentage line rate
# paramaters: the desired percentage of line rate
# returns: the gap in nanoseconds
# usage: gapnano_fromload_forfast-e 50
#############################################################################################
proc gapnano_fromload_forfast-e { load } {
   set max_fast_e_framerate 148810  ;#Legal limit of fast-e frames/s
   set nano 1000000000.0            ;#because we needn't type all those zero more than once
   set crc_bytes 4                  ;#this is the crc bytes for all ethernet types
   set preamble_bits 64             ;#For all ethernet types, this is the preamble bits
   set fast_e_bits 100000000        ;#b/s for fast-e
   set linerate_bits $fast_e_bits   ;#just some indirection
   set min_gap_bits 96              ;#All ethernet flavours, 96 bits!
   set frame_bytes [expr $::packetsize - 4]  ;#Minimum legal Ethernet frame size ( without the CRC)
   #the next few lines do some math to derive the gap in microseconds
   set total_length_bits [expr 8*($frame_bytes + $crc_bytes)+$preamble_bits]
   set max_frames_per_sec [round [expr $linerate_bits.0/($total_length_bits + $min_gap_bits)]]
   set gap_bits [round [expr ($linerate_bits/($max_frames_per_sec * $load / 100.0 )) - $total_length_bits]]
   set gap_nano [expr ($nano * $gap_bits)/$linerate_bits.0]
   set ::pps [round [expr $linerate_bits.0/($total_length_bits + $gap_bits)]]
   return $gap_nano
}

###########################################################################################################################################################################################
# Brett-Documenation
#
# proc vpivci
# --------------
# purpose: create a cell header using vpi/vci
# paramaters: the desired vpi/vci
# returns: the cellheader
# usage: vpivci 0 9
#############################################################################################
proc vpivci { vpi vci } {
set vpi [expr $vpi * 0x00100000]
set vci [expr $vci * 0x00000010]
set cellheader [expr $vpi + $vci]
#puts "The Cell Header is [format %08X $cellheader]"
return $cellheader
}

###########################################################################################################################################################################################
# Brett-Documenation
#
# proc round
# --------------
# purpose: round up a IMAGINARY number
# paramaters: the number
# returns: the number rounded up
# usage: round 1.3333335 will result in 1.333334
#############################################################################################
proc round { i } {
set j [split $i .]
set k [lindex $j 0]
set l [lindex $j 1]
for { set m [string length $l] } { $m > 0 } { incr m -1 } {
   if { [string index $l $m] > 4 } {
      set n [string index $l [expr $m -1] ]
      if { $n == 9 } {
         set n 0
      } else {
         set n [expr $n+1]
         set o [string range $l 0 [expr $m -2] ]
         set l $o$n
      }
   } else {
      set l [string range $l 0 [expr $m -1] ]
   }
   #puts "l:$l"
}
set p [string trimright $l 0]
#puts $p
if { $p != "" } { if {$p > 4} { incr k  } }
return $k
}

###########################################################################################################################################################################################
# Brett-Documenation
#
# proc vfd
# --------------
# purpose: set the vfd
# paramaters: h/s/p
# returns: nothing
# usage: vfd 0 5 0
#############################################################################################
proc vfd { h s p } {
    struct_new vfdstruct HTVFDStructure
    set vfdstruct(Configuration) $::HVFD_STATIC
    set vfdstruct(Range) 6
    set vfdstruct(Offset) 0

    struct_new vfd1Data Int*6
    set vfd1Data(0.i) 0x66
    set vfd1Data(1.i) 0x55
    set vfd1Data(2.i) 0x44
    set vfd1Data(3.i) 0x33
    set vfd1Data(4.i) 0x22
    set vfd1Data(5.i) 0x11
    set vfdstruct(Data) vfd1Data
    set vfdstruct(DataCount) 0
    CheckError HTVFD $::HVFD_1 vfdstruct $h $s $p
    unset vfd1Data

    struct_new vfd2Data Int*6
    set vfd2Data(0.i) 0xAA
    set vfd2Data(1.i) 0xBB
    set vfd2Data(2.i) 0xCC
    set vfd2Data(3.i) 0xDD
    set vfd2Data(4.i) 0xEE
    set vfd2Data(5.i) 0xFF
    set vfdstruct(Data) vfd2Data
    set vfdstruct(DataCount) 0
    set vfdstruct(Offset) 48
    CheckError HTVFD $::HVFD_2 vfdstruct $h $s $p
}

proc trigger { h s p } {
    struct_new ts HTTriggerStructure
    set ts(Offset) 0
    set ts(Range) 6
    # Will match 11 22 33 44 55 66
    set ts(Pattern.0) 0x66
    set ts(Pattern.1) 0x55
    set ts(Pattern.2) 0x44
    set ts(Pattern.3) 0x33
    set ts(Pattern.4) 0x22
    set ts(Pattern.5) 0x11
    CheckError HTTrigger $::HTTRIGGER_1 $::HTTRIGGER_ON ts $h $s $p
    set ts(Offset) 48
    # Will match FF EE DD CC BB AA
    set ts(Pattern.0) 0xAA
    set ts(Pattern.1) 0xBB
    set ts(Pattern.2) 0xCC
    set ts(Pattern.3) 0xDD
    set ts(Pattern.4) 0xEE
    set ts(Pattern.5) 0xFF
    CheckError HTTrigger $::HTTRIGGER_2 $::HTTRIGGER_ON ts $h $s $p
    unset ts
}

###############################################################################################
# Brett-Documenation
#
# proc sip_trigger
# -------------------
# purpose: to set the trigger on a receive port to look for a particular sip on incoming packets
# parameters: h s p sip
# returns: nothing
# usage: trigger 0 5 0 10.0.0.2
#############################################################################################
proc sip_trigger { h s p sip } {
    struct_new ts HTTriggerStructure
    set ts(Offset) 208
    set ts(Range) 4
    set class_a [lindex [split $sip .] 0]
    set class_b [lindex [split $sip .] 1]
    set class_c [lindex [split $sip .] 2]
    set class_d [lindex [split $sip .] 3]

    # Will match 33 44 55 66
    set ts(Pattern.0) $class_d
    set ts(Pattern.1) $class_c
    set ts(Pattern.2) $class_b
    set ts(Pattern.3) $class_a
    LIBCMD HTTrigger $::HTTRIGGER_1 $::HTTRIGGER_ON ts $h $s $p
    unset ts
}

###########################################################################################################################################################################################
# Brett-Documenation
#
# proc whereami
# --------------
# purpose: to print out a number, which shows you were you are! Then it increments it for you.
# parameters: the number to print out
# returns: incr of the param
# usage: set a 0
#        set a [whereami $a]
#        <some more code>
#        set a [whereami $a]
#        <some more code>
#        set a [whereami $a]
#        <some more code>
#        set a [whereami $a]
#############################################################################################
proc whereami { a } { puts "*$a*"; flush stdout; after 200; flush stdout; incr a; return $a }


###########################################################################################################################################################################################
# Brett-Documenation
#
# proc errordumper
# --------------
# purpose: to dump a catastrophic error message to the file, and keep the program going
# parameters: the error string, from catch
# returns: nothing
# usage:
#
# catch { BUGGYPROC buggyparams } theerrorholderstring
#        if { [string length $theerrorholderstring] > 3 } {
#            errordumper $theerrorholderstring
#        }
#############################################################################################
proc errordumper { i } {
    set error_file [open error.txt "a+"]
    puts -nonewline $error_file [clock format [clock seconds] -format %D]
    puts -nonewline $error_file ","
    puts -nonewline $error_file [clock format [clock seconds] -format %T]
    puts -nonewline $error_file ","
    puts $error_file $i
    close $error_file
    puts ""
    puts "************************"
    puts "*    ERRORS OCCURED    *"
    puts "* check file error.txt *"
    puts "************************"
}



###########################################################################################################################################################################################
#Brett-Documenation
#
# Proc printfile
# --------------
# purpose: to print a string to the file, and the screen, if debug is turned on
# parameters: i:the file handle, or -nonewline
#             j:the file handle, or if -nonewline in i, then the string
#             k:if -nonewline, the string to print, else noop
# returns: nothing
#
#############################################################################################
proc printfile { i { k 0 } } {
    global debug filehandle
    if { $i == "-nonewline" } {
        puts -nonewline $filehandle $k
        if { $debug } { puts -nonewline $k }
    } else {
        puts $filehandle $i
        if { $debug } { puts $i }
    }
}


###########################################################################################################################################################################################
#Brett-Documenation
#
# Proc startlog
# --------------
# purpose: to open a log file and timestamp it.
# parameters: the filename you want to use
# returns: the handle
#
#############################################################################################
proc startlog { filename } {
	 set seconds [split [clock format [clock seconds] -format %T] :]
	 set seconds [join $seconds _]
	 set date [split [clock format [clock seconds] -format %D] /]
	 set date [join $date _]
    set filename $filename\_$date\_$seconds\.txt
    set log_file [open $filename  "w+"]
#    puts -nonewline $log_file [clock format [clock seconds] -format %D]
#    puts -nonewline $log_file ","
#    puts $log_file [clock format [clock seconds] -format %T]
    return $log_file
}

###########################################################################################################################################################################################
#Brett-Documenation
#
# Proc Watchthis
# --------------
# purpose: to send to stdout some debug messages
# parameters: two strings, the first one typically a var and the second the var value
# returns: nothing
#
#############################################################################################
proc watchthis { one two } { puts -nonewline $one; puts -nonewline ":"; puts -nonewline $two; puts -nonewline ";" }

##############################################################################################
#Brett-Documenation
#
# Proc IsNumeric
# -----------
# purpose: to see if a given char is a number
# parameters: the char
# returns: -1 if not numeric, 1 if so
#
#############################################################################################
proc isnumeric { character } {
    set retval -1
    for {set i 0} {$i < 10} {incr i} {
        if { $character == $i } {
            set retval 1
        }
    }
    return $retval
}

##############################################################################################
#Brett-Documenation
#
# Proc Numerize
# -------------
# purpose: to produce a string of 1 and 0's, that represent in ordinal positions where
#         corresponding numbers occur in the input string
# parameters: the string
# returns: an identically long string, but each character replaced with a 0 and number with 1
#
#############################################################################################
proc numerize  { str } {
    set strlen [string length $str]
    set ii ""
    for {set i 0} { $i < $strlen } { incr i } {
        set iii [isnumeric [string index $str $i]]
        if { $iii > 0 } {
            append ii 1
        } else {
            append ii 0
        }
    }
    return $ii
}

##############################################################################################
#Brett-Documenation
#
# Proc LeftRight
# -------------
# purpose: to produce two strings out of one, splitting them where a number occurs
# parameters: the string
# returns: a list of two strings, "left" and "right", the "left" being everything in the
#          first string to the left of the
#          the first number in the first string, and the "right" everything else.
#
#############################################################################################
proc leftright { str } {
    set lhand ""
    set rhand ""
    set numer [numerize $str]
    for { set i 0 } { $i < [string length $str] } {incr i } {
        if { [string index $numer $i] == 1 } {
            break
        }
        append lhand [string index $str $i]
    }
    for {} { $i < [string length $str] } {incr i } {
        append rhand [string index $str $i]
    }
    lappend retval $lhand
    lappend retval $rhand
    return $retval
}


##############################################################################################
#Brett-Documenation
#
# Proc HowmanyZeroes
# -------------
# purpose: counts the number of leading zeroes in a string
# parameters: the string
# returns: the quantity of leading zeroes in a string
#
#############################################################################################
proc howmanyzeroes { str } {
    set retval 0
    set l [string length $str]
    for {set i 0} {$i < $l} {incr i} {
        if {[string index $str $i] == "0"} {
            set retval [expr $retval +1]
        } else {
            break
        }
    }
    return $retval
}

##############################################################################################
#Brett-Documenation
#
# Proc addonetocrazystring
# -------------
# purpose: to take a general string of the format xxxxyyyyy where xxxx is of any length and
#          is characterbased, and yyyy is of any length and is numeric, and add one to the
#          numeric portion, handling rollover and leading zeroes.
#
# parameters: the string
# returns: same string plus 1
#
#############################################################################################
proc addonetocrazystring { thestring } {
    set newnumber ""
    set i [leftright $thestring]
    #watchthis "left" [lindex $i 0]
    #watchthis "right"  [lindex $i 1]
    set lh [lindex $i 0]
    set rh [lindex $i 1]
    set totalzeroes [howmanyzeroes $rh]
    #watchthis "zero" $totalzeroes
    set rh [string trimleft $rh 0]
    #watchthis "rh" $rh
    set rhl [string length [expr $rh +1]]
    #watchthis "rhlen" $rhl
    #for each character in rh over 1, subtract a zero, but
    #not so much that it gets shorter than what was passed in

    #here, we take off the zeroes
    for {set i 1} { $i < $rhl } { incr i } {
        set totalzeroes [expr $totalzeroes -1]
    }
    #watchthis "zero" $totalzeroes
    #This if/else is if rh is all zeroes, we don't add any
    if {$rh != ""} {
        for {set i 0} { $i < $totalzeroes } {incr i} {
            append newnumber 0
        }
        } else {
        for {set i 0} { $i < [expr $totalzeroes-1] } {incr i} {
            append newnumber 0
        }
    }
    ##########################
    #Brett-Documentation
    #
    #Now, before we put the number on, let's check if its length would be equal to
    #the length of what was passed in! If not, add zero's until it is!
    #
    ##########################
    set i $newnumber
    append i [expr $rh +1]
    set i $lh$i
    while { [string length $i] < [string length $thestring] } {
        append newnumber 0
        set i $newnumber
        append i [expr $rh +1]
        set i $lh$i
    }
    append newnumber [expr $rh +1]
    set newnumber $lh$newnumber
    return $newnumber
};#end proc addtocrazystring

##############################################################################################
#Brett-Documenation
#
# Proc DottedQuad
# -----------
# purpose: to take an ip address and add 1 to it, handling rollover
# parameters: aaa, the ip address as a string in the format 192.168.11.232
# returns: the same string, incremented by 1
#
#############################################################################################
proc dottedquad { aaa } {
    set dottedquad [split $aaa "."]
    for { set iii 3 } { $iii >= 0 } {incr iii -1} {
        if { $iii == 3 } {
        if { [lindex $dottedquad 3] < 254 } {
        set blah [lreplace $dottedquad 3 3 [expr [lindex $dottedquad 3] + 1]]
        set aaa [join $blah "."]
        break
        } ;#endif we don't want to broadcast to all ip in last octet
        } elseif { [lindex $dottedquad $iii] < 255 } {
        set blah [lreplace $dottedquad $iii $iii [expr [lindex $dottedquad $iii] + 1]]
        set blah [lreplace $blah 3 3 0]
        set aaa [join $blah "."]
        break
        };#endif we are under 254 and not on last octet ( 3 being last octet!)
    } ;#end loop of dotted quads
    return $aaa
};#endproc dottedquad


##############################################################################################
# Brett-Documenation
#
# Proc Sixmac
# -----------
# purpose: to take a mac address and add 1 to it, handling rollover
# parameters: aaa, the mac address as a string in the format 255-255-255-255-255-255
# returns: the same string, incremented by 1
#
##############################################################################################
proc sixmac { aaa } {
    set 6mac [split $aaa "-"]
    for { set iii 5 } { $iii >= 0 } {incr iii -1} {
        if { $iii == 5 } {
        if { [lindex $6mac $iii] < 255 } {
            set blah [lreplace $6mac $iii $iii [expr [lindex $6mac $iii] + 1]]
            set aaa [join $blah "-"]
            break
        } ;#end we are done with the last "mac-tet"
        } elseif { [lindex $6mac $iii] < 255 } {
            set blah [lreplace $6mac $iii $iii [expr [lindex $6mac $iii] + 1]]
            set blah [lreplace $blah 5 5 0]
            set aaa [join $blah "-"]
            break
        };#endif we are under 254 and not on last octet ( 3 being last octet!)
    } ;#end loop of macs
    return $aaa
};#endproc sixmac

##############################################################################################
# Brett-Documenation
#
# Proc gap_nanoseconds
# --------------------
# purpose: to return the gap in nanoseconds for ethernet, given the load (% of linerate)
#          requires the function "round"
# parameters: the %load as a real number
# returns: the gap in nanoseconds
#
##############################################################################################
proc gap_nanoseconds { load } {
set max_fast_e_framerate 148810  ;#Legal limit of fast-e frames/s
set nano 1000000000.0            ;#because we needn't type all those zero more than once
set crc_bytes 4                  ;#this is the crc bytes for all ethernet types
set preamble_bits 64             ;#For all ethernet types, this is the preamble bits
set fast_e_bits 100000000        ;#b/s for fast-e
set linerate_bits $fast_e_bits   ;#just some indirection
set min_gap_bits 96              ;#All ethernet flavours, 96 bits!
set frame_bytes 60               ;#Minimum legal Ethernet frame size ( without the CRC)
#the next few lines do some math to derive the gap in microseconds
set total_length_bits [expr 8*($frame_bytes + $crc_bytes)+$preamble_bits]
set max_frames_per_sec [round [expr $linerate_bits.0/($total_length_bits + $min_gap_bits)]]
set gap_bits [round [expr ($linerate_bits/($max_frames_per_sec * $load / 100.0 )) - $total_length_bits]]
set gap_nano [expr ($nano * $gap_bits)/$linerate_bits.0]
return $gap_nano
}

##############################################################################################
# Brett-Documenation
#
# Proc gap_bits
# -----------
# purpose: to return the gap in bits
# parameters: the %load as a real number
# returns: the gap in bits
#
##############################################################################################
proc gap_bits { load } {
set max_fast_e_framerate 148810  ;#Legal limit of fast-e frames/s
set nano 1000000000.0            ;#because we needn't type all those zero more than once
set crc_bytes 4                  ;#this is the crc bytes for all ethernet types
set preamble_bits 64             ;#For all ethernet types, this is the preamble bits
set fast_e_bits 100000000        ;#b/s for fast-e
set linerate_bits $fast_e_bits   ;#just some indirection
set min_gap_bits 96              ;#All ethernet flavours, 96 bits!
set frame_bytes 60
#Larocca Method
set frame_bytes [expr $frame_bytes + 4]
set gap_in_bytes [expr int([expr (($frame_bytes + 20)/($load / 100.0))-$frame_bytes-8])]
set gap_in_bits [expr int([expr $gap_in_bytes * 8])]
#set gap_nano [expr ($gap_in_bits * $nano)/$linerate_bits.0]
return $gap_bits
}

##############################################################################################
# Brett-Documenation
#
# Proc gap_nano_from_bits
# -----------
# purpose: to return the gap in nanoseconds for ethernet, given the load (% of linerate)
#          this one uses a shorter, possible more accurate method than gap_nanoseconds
# parameters: the %load as a real number
# returns: the gap in nanoseconds
#
##############################################################################################
proc gap_nano_from_bits { load } {
#Larocca Method
set frame_bytes [expr $frame_bytes + 4]
set gap_in_bytes [expr int([expr (($frame_bytes + 20)/($load / 100.0))-$frame_bytes-8])]
set gap_in_bits [expr int([expr $gap_in_bytes * 8])]
set gap_nano [expr ($gap_in_bits * $nano)/$linerate_bits.0]
return $gap_nano
}

#needs QA-ing, not totally accurate
proc PPS { wirerate packsize ipg } {
set preamble 8.0
set gap [expr $ipg * 100.0]
set overheadbits [expr [expr $preamble * 8.0] + $gap ]
set databits [expr $packsize * 8.0]
set pps [expr $wirerate / [expr $databits + $overheadbits]]
return $pps
}

#needs QA-ing, not totally accurate
proc GAP { wirerate packsize pps } {
set preamble 8.0
set overheadbitswithoutgap [expr $preamble * 8.0]
set databits [expr $packsize * 8.0]
set linerateslashpps [expr $wirerate / $pps]
set totalbits [expr $databits + $overheadbitswithoutgap]
set gap [expr $linerateslashpps - $totalbits]
return $gap
}

