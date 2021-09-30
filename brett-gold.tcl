source "c:/my documents/_source/smartlib.tcl"
source srapi.tcl
source "c:/my documents/_source/misc.tcl"
source scpkg_extern.tcl
#package require smartlib
package require libcmds
source scpkg_init.tcl
source "c:/my documents/_source/brettlib/brettlib.tcl"

#globals
set trdhandle0 0

proc init_stack { h s p } {
	 lputs -nonewline "initializing stack:"; flush stdout
    global trdhandle0
    lputs [LIBCMD smbStartTrd $h $s $p trdhandle0]
}

proc shutdown_stack { h s p } {
	 lputs -nonewline "shutting down stack:"; flush stdout
    global trdhandle0
    lputs [LIBCMD smbStopTrd $trdhandle0 $h $s $p]
}

proc main { } {
source config.txt

# connect and reserve ports
lputs "Linking to $smb_chassis_ip"
#LIBCMD ETSocketLink $smb_chassis_ip 16385
EX_SocketLink $smb_chassis_ip 16385 $::RESERVE_NONE
lputs "Reserving $h1/$s1/$p1 and $h2/$s2/$p2 ( could be same slot, that's OK )"
LIBCMD HTSlotReserve $h1 $s1
LIBCMD HTSlotReserve $h2 $s2

#set owners [list {Reserved-other} {Reserved-user} {Available} {Unknown}]
#set model ""
#set iCardT [HTGetCardModel model $h1 $s1 $p1]
#set EX::CardProps($h1.$s1.$p1,CardModel) $model
#set EX::CardProps($h1.$s1.$p1,FWVer) [EX_ReturnFWVersion $h1 $s1 $p1]
#set ownership [HTSlotOwnership $h1 $s1]
#set tmpList [list $h1 $s1 $p1 $model $EX::CardProps($h1.$s1.$p1,FWVer) [lindex $owners $ownership]]
#lappend EX::PortList $tmpList
#set EX::CardProps($h1.$s1.$p1,CaptureState) $::OFF
#set EX::CardProps($h1.$s1.$p1,Chassis) $EX::SMB6000
#set EX::CardProps($h1.$s1.$p1,MIICapable) $::OFF
#set EX::CardProps($h1.$s1.$p1,StrucType) $EX::L3_STRUC
#set EX::CardProps($h1.$s1.$p1,ATMType2) $::OFF
#set EX::CardProps($h1.$s1.$p1,L3CapSetupReq) $::OFF
#set EX::CardProps($h1.$s1.$p1,L3CounterEthExReq) $::OFF
#set EX::CardProps($h1.$s1.$p1,L3StrExt) $::OFF
#set EX::CardProps($h1.$s1.$p1,WANStrExt) $::OFF
#set EX::CardProps($h1.$s1.$p1,L3Capable) $::ON
#set EX::CardProps($h1.$s1.$p1,ARPCapable) $::ON
#set EX::CardProps($h1.$s1.$p1,BitRate) 10000000
#set EX::CardProps($h1.$s1.$p1,PktOverHead) 12
#set model ""
#set iCardT [HTGetCardModel model $h2 $s2 $p2]
#set EX::CardProps($h2.$s2.$p2,CardModel) $model
#set EX::CardProps($h2.$s2.$p2,FWVer) [EX_ReturnFWVersion $h2 $s2 $p2]
#set ownership [HTSlotOwnership $h2 $s2]
#set tmpList [list $h2 $s2 $p2 $model $EX::CardProps($h2.$s2.$p2,FWVer) [lindex $owners $ownership]]
#lappend EX::PortList $tmpList
#set EX::CardProps($h2.$s2.$p2,CaptureState) $::OFF
#set EX::CardProps($h2.$s2.$p2,Chassis) $EX::SMB6000
#set EX::CardProps($h2.$s2.$p2,MIICapable) $::OFF
#set EX::CardProps($h2.$s2.$p2,StrucType) $EX::L3_STRUC
#set EX::CardProps($h2.$s2.$p2,ATMType2) $::OFF
#set EX::CardProps($h2.$s2.$p2,L3CapSetupReq) $::OFF
#set EX::CardProps($h2.$s2.$p2,L3CounterEthExReq) $::OFF
#set EX::CardProps($h2.$s2.$p2,L3StrExt) $::OFF
#set EX::CardProps($h2.$s2.$p2,WANStrExt) $::OFF
#set EX::CardProps($h2.$s2.$p2,L3Capable) $::ON
#set EX::CardProps($h2.$s2.$p2,ARPCapable) $::ON
#set EX::CardProps($h2.$s2.$p2,BitRate) 100000000
#set EX::CardProps($h2.$s2.$p2,PktOverHead) 12

set cm ""; set fw ""
LIBCMD HTGetCardModel cm $h1 $s1 $p1
set ver [EX_ReturnFWVersion $h1 $s1 $p1]
lputs "$h1/$s1/$p1 = $cm FW:$ver"
LIBCMD HTGetCardModel cm $h2 $s2 $p2
set ver [EX_ReturnFWVersion $h2 $s2 $p2]
lputs "$h2/$s2/$p2 = $cm FW:$ver"

# start stack
shutdown_stack	$h1 $s1 $p1
shutdown_stack	$h2 $s2 $p2
after 1000
init_stack $h1 $s1 $p1
init_stack $h2 $s2 $p2
after 1000

LIBCMD smbSet $::SR_SYSTEM_HANDLE SR_ATTR_szLogFileName "log.txt"

# create test
set testhandle [smbCreate "SR_CLASS_Test"]

# set test attributes
LIBCMD smbSet $testhandle SR_ATTR_ulDurationInSec 10

########################################
############  Port 1 Setup  ############
########################################
#
##general
#set bgp_p1 [smbAdd $testhandle "SR_CLASS_Port"]
#LIBCMD smbSet $bgp_p1 SR_ATTR_hspHubSlotPort "$h1,$s1,$p1"
#LIBCMD smbSet $bgp_p1 SR_ATTR_szName $portname1
#LIBCMD smbSet $bgp_p1 SR_ATTR_bEnable True
#LIBCMD smbSet $bgp_p1 SR_ATTR_bRandom False
#LIBCMD smbSet $bgp_p1 SR_ATTR_ulBurstSize 1
#LIBCMD smbSet $bgp_p1 SR_ATTR_uiTrafficType $p1_action
##LIBCMD smbSet $bgp_p1 SR_ATTR_dTrafficLoadPercent $p1_trafficload_percent
##LIBCMD smbSet $bgp_p1 SR_ATTR_dMinRandomTrafficLoadPercent $p1_trafficload_percent
##LIBCMD smbSet $bgp_p1 SR_ATTR_dMaxRandomTrafficLoadPercent $p1_trafficload_percent
#
##layer 1
#LIBCMD smbSet $bgp_p1 SR_ATTR_uiSpeed $speed1
#LIBCMD smbSet $bgp_p1 SR_ATTR_uiDuplex $duplex1
##LIBCMD smbSet $bgp_p1 SR_ATTR_uiAutoNegotiation $autonegotiation1
##LIBCMD smbSet $bgp_p1 SR_ATTR_bFlowControl $flowcontrol1
#
##layer 2
#LIBCMD smbSet $bgp_p1 SR_ATTR_macMacAddress $smac1
#
##later 3
#LIBCMD smbSet $bgp_p1 SR_ATTR_ipIpAddress $sip1
#LIBCMD smbSet $bgp_p1 SR_ATTR_ipGateway $gtw1
#LIBCMD smbSet $bgp_p1 SR_ATTR_ipNetmask $mask1
#LIBCMD smbSet $bgp_p1 SR_ATTR_bArpGateway True
#
########################################
############  Port 2 Setup  ############
########################################
#
##general
#set bgp_p2 [smbAdd $testhandle "SR_CLASS_Port"]
#LIBCMD smbSet $bgp_p2 SR_ATTR_hspHubSlotPort "$h2,$s2,p2"
#LIBCMD smbSet $bgp_p2 SR_ATTR_szName $portname2
#LIBCMD smbSet $bgp_p2 SR_ATTR_bEnable True
#LIBCMD smbSet $bgp_p2 SR_ATTR_bRandom False
#LIBCMD smbSet $bgp_p2 SR_ATTR_ulBurstSize 1
#LIBCMD smbSet $bgp_p2 SR_ATTR_uiTrafficType $p2_action
##LIBCMD smbSet $bgp_p2 SR_ATTR_dTrafficLoadPercent $p2_trafficload_percent
##LIBCMD smbSet $bgp_p2 SR_ATTR_dMinRandomTrafficLoadPercent $p2_trafficload_percent
##LIBCMD smbSet $bgp_p2 SR_ATTR_dMaxRandomTrafficLoadPercent $p2_trafficload_percent
#
##layer 1
#LIBCMD smbSet $bgp_p2 SR_ATTR_uiSpeed $speed2
#LIBCMD smbSet $bgp_p2 SR_ATTR_uiDuplex $duplex2
##LIBCMD smbSet $bgp_p2 SR_ATTR_uiAutoNegotiation $autonegotiation2
##LIBCMD smbSet $bgp_p2 SR_ATTR_bFlowControl $flowcontrol2
#
##layer 2
#LIBCMD smbSet $bgp_p2 SR_ATTR_macMacAddress $smac2
#
##layer 3
#LIBCMD smbSet $bgp_p2 SR_ATTR_ipIpAddress $sip2
#LIBCMD smbSet $bgp_p2 SR_ATTR_ipGateway $gtw2
#LIBCMD smbSet $bgp_p2 SR_ATTR_ipNetmask $mask2
#LIBCMD smbSet $bgp_p2 SR_ATTR_bArpGateway True

# add ports
set bgp_p1 [smbAdd $testhandle "SR_CLASS_Port"]
LIBCMD smbSet $bgp_p1 SR_ATTR_hspHubSlotPort "$h1,$s1,$p1"
set bgp_p2 [smbAdd $testhandle "SR_CLASS_Port"]
LIBCMD smbSet $bgp_p2 SR_ATTR_hspHubSlotPort "$h2,$s2,$p2"

# set port 0 attributes
LIBCMD smbSet $bgp_p1 SR_ATTR_uiTrafficType $::SR_VALUE_PORT_RECV_ONLY
LIBCMD smbSet $bgp_p1 SR_ATTR_macMacAddress $smac1
LIBCMD smbSet $bgp_p1 SR_ATTR_ipIpAddress $sip1
LIBCMD smbSet $bgp_p1 SR_ATTR_ipGateway $gtw1
LIBCMD smbSet $bgp_p1 SR_ATTR_ipNetmask $mask1
LIBCMD smbSet $bgp_p1 SR_ATTR_uiSpeed $speed1
LIBCMD smbSet $bgp_p1 SR_ATTR_uiDuplex 1


# set port 1 attributes
LIBCMD smbSet $bgp_p2 SR_ATTR_uiTrafficType $::SR_VALUE_PORT_RECV_ONLY
LIBCMD smbSet $bgp_p2 SR_ATTR_macMacAddress $smac2
LIBCMD smbSet $bgp_p2 SR_ATTR_ipIpAddress $sip2
LIBCMD smbSet $bgp_p2 SR_ATTR_ipGateway $gtw2
LIBCMD smbSet $bgp_p2 SR_ATTR_ipNetmask $mask2
LIBCMD smbSet $bgp_p2 SR_ATTR_uiSpeed $speed2
LIBCMD smbSet $bgp_p2 SR_ATTR_uiDuplex 1

#######################################
##########  BGP Session  ##############
#######################################

set bgp_sess [smbAdd $bgp_p2 SR_CLASS_BgpSession]
LIBCMD smbSet $bgp_sess SR_ATTR_uiHoldTime $holdtime
LIBCMD smbSet $bgp_sess SR_ATTR_uiKeepAlive $keepalive
LIBCMD smbSet $bgp_sess SR_ATTR_uiUpdateCount $update_count
LIBCMD smbSet $bgp_sess SR_ATTR_uiUpdateDelay $update_delay
LIBCMD smbSet $bgp_sess SR_ATTR_uiConnectionRetryCount $connection_retry
LIBCMD smbSet $bgp_sess SR_ATTR_uiConnectionRetryInterval $conn_retry_interval
LIBCMD smbSet $bgp_sess SR_ATTR_uiAs $my_as
LIBCMD smbSet $bgp_sess SR_ATTR_uiPeerAs $peer_as
LIBCMD smbSet $bgp_sess SR_ATTR_ipIp $bgp_ip
LIBCMD smbSet $bgp_sess SR_ATTR_ipId $bgp_ip_id
LIBCMD smbSet $bgp_sess SR_ATTR_ipPeerIp $peer_ip
LIBCMD smbSet $bgp_sess SR_ATTR_bInitiate True

set routegen ""
LIBCMD smbGet $testhandle SR_ATTR_hrRouteGeneration routegen
LIBCMD smbSet $routegen SR_ATTR_uiStartIndex $startprefix
LIBCMD smbSet $routegen SR_ATTR_uiEndIndex $endprefix
LIBCMD smbSet $routegen SR_ATTR_ulRouteCnt $num_routes
LIBCMD smbSet $routegen SR_ATTR_dPercentDuplicated $percent_duplicated
LIBCMD smbPerform $routegen SR_OP_ApplyControl

set iterator ""
LIBCMD smbGet $routegen SR_ATTR_hrPrefixEntryIterator iterator
LIBCMD smbPerform $iterator SR_OP_Reset

set temp ""
LIBCMD smbGet $iterator SR_ATTR_hrData temp
set routeass ""
LIBCMD smbGet $testhandle SR_ATTR_hrRouteAssignment routeass
LIBCMD smbSet $routeass SR_ATTR_uiDistinctRouteDistributionType $::SR_VALUE_EQUAL_DISTRIBUTION
LIBCMD smbSet $routeass SR_ATTR_uiDuplicateRouteDistributionType $::SR_VALUE_EQUAL_DISTRIBUTION
LIBCMD smbSet $routeass SR_ATTR_bAggregate False
LIBCMD smbPerform $routeass SR_OP_ApplyControl
LIBCMD smbSet $routeass SR_ATTR_szPrimaryIntermediateAsList 1000,
LIBCMD smbSet $routeass SR_ATTR_szSecondaryIntermediateAsList 2000,3000,

set routeassiterator ""
LIBCMD smbGet $routeass SR_ATTR_hrRouteAssignmentEntryIterator routeassiterator
LIBCMD smbPerform $routeassiterator SR_OP_Reset
set neverused ""
LIBCMD smbGet $routeassiterator SR_ATTR_hrData neverused

set temp ""
LIBCMD smbGet $routeassiterator SR_ATTR_hrData temp
LIBCMD smbGet $testhandle SR_ATTR_hrRouteAssignment routeass
LIBCMD smbGet $routeass SR_ATTR_hrRouteAssignmentEntryIterator routeassiterator
LIBCMD smbPerform $routeassiterator SR_OP_Reset

set temp ""
LIBCMD smbGet $routeassiterator SR_ATTR_hrData temp
LIBCMD smbPerform $routeass SR_OP_GenerateRoute

#set traff_gen ""
#LIBCMD smbGet $testhandle SR_ATTR_hrTrafficGeneration traff_gen
#LIBCMD smbSet $traff_gen SR_ATTR_ucTimeToLive $ttl
#LIBCMD smbSet $traff_gen SR_ATTR_bRandom False
#LIBCMD smbSet $traff_gen SR_ATTR_ulFrameSize $framesize
#
#set traff_gen_att1 [smbAdd $traff_gen SR_CLASS_TrafficGenerationAttribute]
#LIBCMD smbSet $traff_gen_att1 SR_ATTR_uiAttributeType $::SR_VALUE_PROTOCOL
#LIBCMD smbSet $traff_gen_att1 SR_ATTR_ulAttributeValue 6
#LIBCMD smbSet $traff_gen_att1 SR_ATTR_ulAttributeValue1 0
#
#set traff_gen_att2 [smbAdd $traff_gen SR_CLASS_TrafficGenerationAttribute]
#LIBCMD smbSet $traff_gen_att2 SR_ATTR_uiAttributeType $::SR_VALUE_TOS
#LIBCMD smbSet $traff_gen_att2 SR_ATTR_ulAttributeValue 0
#LIBCMD smbSet $traff_gen_att2 SR_ATTR_ulAttributeValue1 0
#
#set traff_gen_att3 [smbAdd $traff_gen SR_CLASS_TrafficGenerationAttribute]
#LIBCMD smbSet $traff_gen_att3 SR_ATTR_uiAttributeType $::SR_VALUE_PREFIXLENGTH
#LIBCMD smbSet $traff_gen_att3 SR_ATTR_ulAttributeValue $prefixlen
#LIBCMD smbSet $traff_gen_att3 SR_ATTR_ulAttributeValue1 0
#LIBCMD smbPerform $traff_gen SR_OP_GenerateTraffic

set flapper ""
LIBCMD smbGet $testhandle SR_ATTR_hrFlapGeneration flapper
LIBCMD smbSet $flapper SR_ATTR_ulFlapWaitTime $flap_seconds
LIBCMD smbSet $flapper SR_ATTR_ulReAdvertiseWaitTime $unflap_seconds
LIBCMD smbSet $flapper SR_ATTR_dPercentDuplicatedRoute 100
LIBCMD smbSet $flapper SR_ATTR_dPercentDistinctRoute 100
LIBCMD smbSet $flapper SR_ATTR_uiFlapType $::SR_VALUE_SINGLE_FLAP
LIBCMD smbPerform $flapper SR_OP_GenerateFlap

LIBCMD smbSet $testhandle SR_ATTR_bHaltAfterTest True
LIBCMD smbSet $testhandle SR_ATTR_ulDurationInSec $test_time_seconds
LIBCMD smbSet $testhandle SR_ATTR_szReportFileName $report_file
LIBCMD smbPerform $::SR_SYSTEM_HANDLE SR_OP_FullDump
LIBCMD smbSet $::SR_SYSTEM_HANDLE SR_ATTR_bIgnoreError $ignore_error

lputs "Setting up ports"
LIBCMD smbPerform $testhandle SR_OP_SetupPort

lputs "###################################################################"
lputs "#                                                                 #"
lputs "#                         DATA PLANE                              #"
lputs "#                         **********                              #"
lputs "#           SmartBits Interface [format %-26s $h1/$s1/$p1]        #"
lputs "#           ----------------------------                          #"
lputs "#           PacketSize:[format %-42s $frame_size] #"
lputs "#           DMAC:(arp)                                            #"
lputs "#           SMAC:[format %-48s $stream_smac] #"
lputs "#           SIP :[format %-48s $stream_sip] #"
lputs "#           DIP :[format %-48s $stream_dip] #"
lputs "#           GTW :[format %-48s $stream_gtw] #"
lputs "#                                                                 #"
lputs "#           Num Streams        :[format %-33s $num_streams] #"
lputs "#           Packets Per Stream :[format %-33s $burst_count] #"
lputs "#           Packets per Second :[format %-33s $pps] #"
set totpak [expr $burst_count * $num_streams]
lputs "#           Total Burst        :[format %-33s $totpak] #"
set totpps [expr $pps * $num_streams]
lputs "#           Total Data Rate    :[format %-33s $totpps] #"
set data_runtime [expr $totpak / $totpps]
lputs "#           Data Plane Run Time:[format %-33s $data_runtime] #"
lputs "#           Clearing Streams on [format %-10s $h1/$s1/$p1]                    #"
EX_ClearStreams $h1 $s1 $p1
lputs "#           Clearing Streams on [format %-10s $h2/$s2/$p2]                    #"
EX_ClearStreams $h2 $s2 $p2

set stream_0 [list \
      -SourceIP "10 1 0 2" \
		-DestinationIP "10 0 0 2" \
		-Netmask "255 255 255 0" \
		-Gateway "10 1 0 1" \
		-SourceMAC "0x00 0x00 0x00 0x00 0x00 0x02" \
		-DestinationMAC "0x00 0x00 0x00 0x00 0x00 0x01" \
		-ulBurstCount 1 \
		-uiFrameLength 60]

EX_SetMLTraffic $h2 $s2 $p2 $::L3_STREAM_IP  [list $stream_0 ]

EX_SetMLTrafficMulti $h1 $s1 $p1 $::L3_STREAM_IP $num_streams \
                    -uiFrameLength $frame_size \
                    -startSrcIP $stream_sip \
                    -incrSrcIP $sip_increment_mask \
                    -startDestIP $stream_dip \
                    -incrDestIP $dip_increment_mask \
                    -gateway $stream_gtw \
                    -startSrcMAC $stream_smac \
                    -ulBurstCount $burst_count \
                    -ulFrameRate $pps

lputs -nonewline "#  Transmitting [format %-3s $num_streams] ARP packet(s) on [format %-10s $h1/$s1/$p1] (1=success):"
lputs -nonewline [EX_Arp $h1 $s1 $p1 2]; lputs -nonewline "#"
lputs -nonewline "#  Transmitting [format %-3s 1] ARP packet(s) on [format %-10s $h2/$s2/$p2] (1=success):"
lputs -nonewline [EX_Arp $h2 $s2 $p2 2]; lputs -nonewline "#"
lputs "#                                                                 #"
lputs "# Clearing Packet Counters on [format %-10s $h1/$s1/$p1]                    #"
HTClearPort $h1 $s1 $p1
lputs "# Clearing Packet Counters on [format %-10s $h2/$s2/$p2]                    #"
HTClearPort $h2 $s2 $p2

#lputs -nonewline "Press \[ENTER\] to Start Sending \
#                 ($burst_count * $num_streams=[expr $burst_count*$num_streams]) packets"
#flush stdout
#gets stdin in


EX_SetSequenceTracking $h2 $s2 $p2

HTRun $::HTRUN $h1 $s1 $p1
after [expr $sample_seconds * 1000]
set c1 [EX_ReturnL2Counters $h1 $s1 $p1]
lputs ""
lputs "Sampling TX Card at +/- $sample_seconds seconds:"
print_counters $h1 $s1 $p1 $c1
lputs "###################################################################"

lputs "opening bgp session"
LIBCMD smbPerform $testhandle SR_OP_OpenBgpSession
lputs "building forwarding table"
LIBCMD smbPerform $testhandle SR_OP_BuildForwardingTable
lputs "building routing table"
LIBCMD smbPerform $testhandle SR_OP_BuildRoutingTable
#lputs "setting up traffic"
#smbPerform $testhandle SR_OP_SetupTraffic
#lputs "please clear counters now!"
#gets stdin inl
lputs "CONTROL PLANE"
lputs "-------------"
lputs "Control Plane Run Time : $test_time_seconds seconds"
lputs "Flap at                : t-zero + $flap_seconds seconds"
lputs "Re-Advertize at        : t-zero + $unflap_seconds seconds"
lputs "---------------------------------------------------------"

LIBCMD smbPerform $testhandle SR_OP_StartTest
EX_Wait4TxStop $h1 $s1 $p1
set c1 [EX_ReturnL2Counters $h1 $s1 $p1]
set c2 [EX_ReturnL2Counters $h2 $s2 $p2]
lputs ""
print_counters $h1 $s1 $p1 $c1
lputs ""
print_counters $h2 $s2 $p2 $c2
set seq [EX_ReturnSequenceTracking $h2 $s2 $p2 ]
#stream
#frames in sequence
#duplicate frames
#lost frames
#set num_streams [llength $seq]
#for { set i 0 } { $i < $num_streams } { incr i } {
#lputs -nonewline "STREAM: [lindex [lindex $seq $i] 0] SEQUENCED FRAMES: [lindex [lindex $seq $i] 1] "
#lputs "LOST FRAMES: [lindex [lindex $seq $i] 3]"
#}

#lputs -nonewline "Hit \[ENTER\] to shutdown bgp"; flush stdout
#gets stdin in;
shutdown_stack	$h1 $s1 $p1
shutdown_stack	$h2 $s2 $p2
LIBCMD HTSlotRelease $h1 $s1
LIBCMD HTSlotRelease $h2 $s2
LIBCMD NSUnLink

}
set LOG_FLAG 1
set LOG_FILE_HANDLE [startlog brettlog.txt]
main
stoplog $::LOG_FILE_HANDLE

