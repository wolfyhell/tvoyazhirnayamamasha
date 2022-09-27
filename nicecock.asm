.data
length: .word 3
target: .word 15

array: .space 400

msg1: .asciiz "Please, enter "
msg2: .asciiz " integers:\n"
newline: .asciiz "\n"

rightBracket: .asciiz "["
comma: .asciiz ","
leftBracket: .asciiz "]"


.text
main:

# prompt message
    la      $a0,        msg1
    addi    $v0,        $zero,          4
    syscall 

    lw      $a0,        length
    addi    $v0,        $zero,          1
    syscall 

    la      $a0,        msg2
    addi    $v0,        $zero,          4
    syscall 

# fill array
    lw      $s0,        length                          # length
    la      $s1,        array                           # element address
    move    $t0,        $zero                           # counter
fillLoop:
    beq     $t0,        $s0,            exitFillLoop


    addi    $v0,        $zero,          5
    syscall 

    sw      $v0,        ($s1)

    addi    $s1,        $s1,            4
    addi    $t0,        $t0,            1
    j       fillLoop

exitFillLoop:

# twoSum
    la      $a0,        array
    lw      $a1,        length
    lw      $a2,        target
    jal     twoSum

    move    $s0,        $v0
    move    $s1,        $v1

# output result
    la      $a0,        rightBracket
    addi    $v0,        $zero,          4
    syscall 

    move    $a0,        $s0
    addi    $v0,        $zero,          1
    syscall 

    la      $a0,        comma
    addi    $v0,        $zero,          4
    syscall 

    move    $a0,        $s1
    addi    $v0,        $zero,          1
    syscall 

    la      $a0,        leftBracket
    addi    $v0,        $zero,          4
    syscall 

    addi    $v0,        $zero,          10
    syscall 

twoSum:

# a0 arr
# a1 length
# a2 target

    addi    $sp,        $sp,            -12
    sw      $s0,        8($sp)
    sw      $s1,        4($sp)
    sw      $s2,        0($sp)

    move    $s0,        $zero                           # sum
    move    $s1,        $zero                           # element address
    move    $s2,        $zero                           # element value

# counters
    move    $t0,        $zero                           # i
    move    $t1,        $zero                           # j

# counters * 4
    move    $t2,        $zero
    move    $t3,        $zero

loop1:
                                                        # while i != length
    beq     $t0,        $a1,            exit1

    move    $s0,        $zero                           # sum = 0

    sll     $t2,        $t0,            2
    add     $s1,        $a0,            $t2             # s1 = arr + i
    lw      $s2,        ($s1)                           # s2 = *(arr + i) = arr[i]

    add     $s0,        $s0,            $s2             # sum += arr[i]
    addi    $t1,        $t0,            1               # j = i + 1
loop2:
                                                        # while j != length
    beq     $t1,        $a1,            exit2

    sll     $t3,        $t1,            2
    add     $s1,        $a0,            $t3             # s1 = arr + j
    lw      $s2,        ($s1)                           # s2 = *(arr + j) = arr[j]

    add     $s0,        $s0,            $s2             # sum += arr[j]

    beq     $s0,        $a2,            found           # if sum == target -> return indexes
    sub     $s0,        $s0,            $s2             # sum -= arr[j]
    j       skipFound
found:
    add     $v0,        $t0,            $zero           # indx1 = i
    add     $v1,        $t1,            $zero           # indx2 = j
    j       exit1
skipFound:
                                                        # ++j
    addi    $t1,        $t1,            1
    j       loop2
exit2:
                                                        # ++i
    addi    $t0,        $t0,            1
    j       loop1
exit1:

    lw      $s0,        8($sp)
    lw      $s1,        4($sp)
    lw      $s2,        0($sp)
    addi    $sp,        $sp,            12

    jr      $ra
