        # TOMER GRADY 205660863

.section	.rodata
    .align 8
    My_Switch:
      .quad .Mission50 	# Case 50: 
      .quad .Mission51	# Case 51:
      .quad .Mission52	# Case 52:
      .quad .Mission53	# Case 53:
      .quad .finish  	
      .quad .wrong 	        
    output_mission50:       .string "first pstring length: %d, second pstring length: %d\n"
    output_mission51:       .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
    output_mission53:       .string "length: %d, string: %s\n"
    wrongInput:             .string "invalid option!\n"
    charInput:              .string " %c"
    intInput:               .string " %d"
    format_str_output:      .string "your string is: %s\n"

  

.text
.globl fun_funcs           
    .type fun_funcs, @function
fun_funcs:
        pushq	%rbp		#save the old frame pointer
	movq	%rsp,	%rbp	#create the new frame pointer

        push %rbx
        push %r12
        push %r13
        
        mov %rsi, %r12                  # first pstring r12 
        mov %rdx, %r13                  # sec pstring r13
        
        leaq -50(%rdi),%rdi	        #check what number we get,  (%rdi fist argument fun)		
        cmpq $4,%rdi
        jae .wrong			
        jmp *My_Switch(,%rdi,8)#activate the mission 
#this function calculates the lenght of 2 pstring and print the results        
.Mission50:
        movq 	%rsi, %rdi 	          #the first string address for getting the size (%rsi sec argument fun)
	call 	pstrlen	                  #calling pstrlen
	movq 	%rax,%r11  	          #save the first lenght size in %r11

    	movq    %rdx,%rdi                  #getting the second string (%rdx sec argument function)  
    	call    pstrlen
	

    	movq 	%r11, %rsi 		  # the second printf argumant = first size
        movq 	%rax, %rdx                 #the 3rd printf argumant   = sec string size    
    	movq 	$output_mission50, %rdi    #the first printf argumant  = string format
    	movq 	$0, %rax	                   #initialize rax 
    	call 	printf			   
    	jmp 	.finish 

# this mission gets 2 chars from the user and replace every occurence of old char in the pstrings, in the new char 
.Mission51:
        #%r12  # first pstring 
        #%r13  # sec pstring

        call input_char
        movq %rax, %rbx                      #old char in %rbx
        call input_char
        # give args to replace char func
        movq %r12,%rdi
        movq %rbx, %rsi
        movq %rax, %rdx                     #new char in %rdx
        pushq   %rax
        call replaceChar
        popq    %rax
        # give args to replace char func
        movq %r13,%rdi
        movq %rbx, %rsi
        movq %rax, %rdx
        pushq   %rax
        call replaceChar
        popq    %rax
        
        
        #print result
        movq $output_mission51, %rdi    #rdi has the format of input
        movq %rbx, %rsi                 #old char to print
        movq %rax, %rdx                 #new char to print
        leaq 1(%r12), %rcx              #move adress for first string to print
        leaq 1(%r13), %r8               #move adress for sec string to print
        xorq %rax, %rax
        call printf 

        jmp .finish

.Mission52:
        #%r12  # first pstring 
        #%r13  # sec pstring
        call input_num
        movzbq %al, %rbx         #first input in rbx

        call input_num
        movzbq %al,%rcx
        movq %r13, %rdi
        movq %r12, %rsi
        movq %rbx, %rdx
        call pstrijcpy
        
        #print result first pstring
        movq %r12, %rdi
        call pstrlen
        movq $0, %rsi
        
        movq %rax, %rsi                 #size to print
        movq $output_mission53, %rdi    #rdi has the format of input
        leaq 1(%r12), %rdx              #move adress for first string to print
        xorq %rax, %rax
        call printf


        #print result sec pstring
        movq %r13, %rdi
        call pstrlen
        movq %rax, %rsi                 #size to print
        movq $output_mission53, %rdi    #rdi has the format of input
        
        leaq 1(%r13), %rdx              #move adress for first string to print
        xorq %rax, %rax
        call printf        
                                   
        jmp .finish
# this mission swaps evey Big letter to littel letter and print the results        
.Mission53:
        
        movq %r12, %rdi
        call swapCase        
        
        #print result first pstring
        movq %r12, %rdi
        call pstrlen
        movq $0, %rsi
        
        movq %rax, %rsi                 #size to print
        movq $output_mission53, %rdi    #rdi has the format of input
        leaq 1(%r12), %rdx              #move adress for first string to print
        xorq %rax, %rax
        call printf

        movq %r13, %rdi
        call swapCase                
 
        #print result sec pstring
        movq $0, %rsi
        call pstrlen
        movq %rax, %rsi                 #size to print
        movq $output_mission53, %rdi    #rdi has the format of input
        
        leaq 1(%r13), %rdx              #move adress for first string to print
        xorq %rax, %rax
        call printf        
                   
        jmp .finish
#wromg input
.wrong:
        movq $wrongInput, %rdi		
    	xor  %rax, %rax
    	call printf
    	xor  %rax,%rax	
#finish jump table
.finish:
        movq -8(%rbp), %rbx
        movq -16(%rbp), %r12
        movq -24(%rbp), %r13
        
        xorq     %rax,%rax
        movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
        popq	%rbp		#restore old frame pointer (the caller function frame)
        ret
	

.globl input_char
    .type input_char,@function
#this function get a char from a user and put it to rax
input_char:
        #get another input
        leaq -1(%rsp), %rsp         # increase stack in 1 byte for char
        
        movq %rsp, %rsi   #move adress for first string variable to rsi
        movq $charInput, %rdi   #rdi has the format of input
        xorq %rax, %rax
        call scanf
        movzbq (%rsp), %rax         #set char in rax
        leaq 1(%rsp), %rsp         # increase stack in 1 byte for char
        ret
        
.globl input_num
    .type   input_num, @function
#this function get a int from the user and put it to rax
input_num:
        leaq -4(%rsp), %rsp         # increase stack in 4 bytes for int
        
        movq %rsp, %rsi   #move adress for first string variable to rsi
        movq $intInput, %rdi   #rdi has the format of input
        xorq %rax, %rax
        call scanf
        movl (%rsp), %eax
        leaq 4(%rsp), %rsp         # increase stack in 4 bytes for int
        ret
