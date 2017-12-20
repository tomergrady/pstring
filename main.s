
    #205660863, Tomer Grady

.section	.rodata	#read only data section

format_int:                     .string "%d"
format_int_output:              .string "your number is: %d\n"
format_string:                  .string "%s\0"
format_str_output:              .string "your string is: %s\n"
format_char:                    .string "%c"
format_char_output:             .string "your char is: %c\n"

.text	#the beginnig of the code
.globl	main	                    #the label "main" is used to state the initial point of this program
	.type	main, @function	        # the label "main" representing the beginning of a function
main:
        movq %rsp, %rbp             #for correct debugging	# the main function:
        pushq	%rbp		        #save the old frame pointer
	    movq	%rsp,	%rbp	    #create the new frame pointer

        pushq %rbx
        pushq %r12
        pushq %r13
  
        call input_num
                
        #back from scanf function        
        subq %rax, %rsp             #make place for the string input + 2
        subq $2, %rsp
        
        movb %al, (%rsp)
        #get the first string
        leaq 1(%rsp), %rsi          #move adress for first string variable to rsi
        movq $format_string, %rdi   #rdi has the format of input
        xorq %rax, %rax
        call scanf

        
        movq %rsp, %rbx              # first pstring        
        
        call input_num
                
        subq %rax, %rsp             #make place for the string input
        subq $2, %rsp
        
        movb %al, (%rsp)
        #get the first string
        leaq 1(%rsp), %rsi          #move adress for first string variable to rsi
        movq $format_string, %rdi   #rdi has the format of input
        xorq %rax, %rax
        call scanf
           
        
        movq %rsp, %r12           # sec pstring

        #get another input
        
        call input_num           # get user input for switch case
        movq %rax, %rdi          #first arg = num for switch case        
        movq %rbx, %rsi
        movq %r12, %rdx
        
        call fun_funcs
        
                                        #recover stack
        movq -8(%rbp), %rbx
        movq -16(%rbp), %r12
        movq -24(%rbp), %r13

        movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
        popq	%rbp		#restore old frame pointer (the caller function frame)
        ret

        
