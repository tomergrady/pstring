    #TOMER GRADY, 205660863


.section .rodata

wrongInput:             .string "invalid input!\n"
formatString:           .string "%s"

.data
.text
#this function gets a pointer to pstring and return its lenght
.global pstrlen
    .type pstrlen, @function
pstrlen:
        xorq %rax, %rax        # rax zero
        movb	(%rdi), %al        # move the first byte of a pstring that means it's size
        ret

#this function gets a pointer to pstring and 2 chars
# the function replace every occurence of old char in new char        
.globl replaceChar
    .type replaceChar,@function
replaceChar:
        #psring in rdi, old char in rsi, new char in rdx 
        movzbq (%rdi), %rax     #check the lengh of the pstring
        leaq 1(%rdi), %r8       #r8 is curr
        leaq (%rax, %r8), %r9   #r9 is end
        cmpq %r8, %r9           #check if we finish the string
        jle .RPLC_END
.RPLC_LOOP:        
        cmpb (%r8), %sil
        jne .RPLC_CONT
        movb %dl, (%r8)

.RPLC_CONT:        
        incq %r8               
        cmpq %r8, %r9
        jg .RPLC_LOOP

.RPLC_END:
        nop
        ret
# this function gets a pointer to pstring and replace every big letter to littel and opposite
.globl swapCase
    .type swapCase,@function
swapCase:
        #pstring in rdi
        call pstrlen
        
        movq $0, %r8
        
        leaq 1(%rdi), %r8       #r8 is curr
        leaq (%rax, %r8), %r9   #r9 is end
        cmpq %r8, %r9
        jle .RPLC_END
.SWAP_LOOP:        
        #saving the current byte in r10( we change it value) and move the new value to r8
	    xorq   %r10,%r10
	    movb   (%r8),%r10b  		#get the first char $%r10 is the curr       
        
        cmp $65, (%r8)                    #check if the asci is less than 65
        jb .SWAP_CONT
        
        cmpq $122, %r10                   #check if its bigger than 122
        ja .SWAP_CONT

        cmpq   $97,%r10   			#if it's  a little letter
	    jae    .LITTEL_LETTER

	    cmpq   $90,%r10			#if it's a big letter
	    jbe     .BIG_LETTER        
                                              
.LITTEL_LETTER:
    	subq  $32,%r10    		#convert to big letter
	    movb  %r10b,(%r8)		#put in the string the new letter
        jmp .SWAP_CONT


.BIG_LETTER:
	    addq  $32,%r10    		#convert to little letter 
	    movb  %r10b,(%r8)		#put in the string the new letter
        jmp .SWAP_CONT

.SWAP_CONT:        
        incq %r8
        cmpq %r8, %r9
        jg .SWAP_LOOP

.SWAP_END:
        nop
        ret        
# this function gets 2 pointers of pstrings and 2 chars numbers (i,j) and copy the sub string src[i,j] into dest[i,j]
#this function returns the pointer to dst pstring
.global pstrijcpy
    .type pstrijcpy, @function
pstrijcpy:
        #first pstring in rdi, sec pstring in rsi
        #char i in rdx, char j in rcx
        
        #if i <0
        testb %dl, %dl
        js .NOT_VALID_IJ
        
        #if j <0
        testb %cl, %cl
        js .NOT_VALID_IJ        
        
        #IF I >JwrongInput
        cmpb %cl, %dl
        ja .NOT_VALID_IJ
        
        #if j>=size1
        cmpb (%rdi), %cl
        jae .NOT_VALID_IJ
        
        #if j>=size2
        cmpb (%rsi), %cl
        jae .NOT_VALID_IJ
        
.LOOP_IJ:
        movb 1(%rdi, %rdx), %al         #src[i] = al
        movb %al, 1(%rsi, %rdx)
        
        incq %rdx
        cmpq %rdx, %rcx
        jae .LOOP_IJ
        
        jmp .DONE_IJ

.NOT_VALID_IJ:
        pushq %rdi
        #print result
        movq $wrongInput, %rdi    #rdi has the format of input
        xorq %rax, %rax
        call printf
        popq %rdi 

.DONE_IJ:              
        movq %rdi, %rax
        ret                                                                                                                                                          

        
        
        
