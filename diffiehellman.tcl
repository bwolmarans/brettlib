puts "A really silly Diffie Helman example in TCL"
puts "-------------------------------------------"
puts ""
puts -nonewline "What is the name of person 1 ? "; flush stdout; gets stdin name1
puts -nonewline "What is $name1's Prime ( must be > 2 ) ? "; flush stdout; gets stdin p1
puts -nonewline "What is $name1's Integer ( must be < $p1 ) ? "; flush stdout; gets stdin i1
puts -nonewline "What is $name1's Random Secret( must be < [expr $p1-1] ) ? "; flush stdout; gets stdin r1
set x1 [expr pow($i1,$r1)]
set pubkey1 [expr int($x1)%$p1]
puts "$name1's public key is $pubkey1"

puts -nonewline "What is the name of person 2 ? "; flush stdout; gets stdin name2
puts "$name2 will use the same Prime and Integer"
puts -nonewline "What is $name2's Random Secret( must be < [expr $p1-2] ) ? "; flush stdout; gets stdin r2
set x2 [expr pow($i1,$r2)]
set pubkey2 [expr int($x2)%$p1]
puts "$name2's public key is $pubkey2"


set y1 [expr pow($pubkey2,$r1)]
set seckey1 [expr int($y1)%$p1]
puts "$name1's secret key is $seckey1"

set y2 [expr pow($pubkey1,$r2)]
set seckey2 [expr int($y2)%$p1]
puts "$name2's secret key is $seckey2"

puts "What is $name1's message to be encoded? We will use a silly XOR encryption ?"; gets stdin $m1

proc toASCII { char } {
scan $char %c value
return $value
}

proc toChar { value } {
return [format %c $value]
}

