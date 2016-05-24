;@author Jaca777
;fastcall, right-to-left
    global readString
    global readChar
    global print
    global concat
    global lengthOf

segment .text

readString: ;(terminator: char on stack, destAddress: char* on rdi) => void
    push rbp
    mov rbp, rsp

  readStringLoop:
    call readChar
    mov byte bl, [rdi]
    inc rdi
    cmp bl, byte [rbp + 16]
    jne readStringLoop
  exitReadStringLoop:
    mov word [rdi], 0x0

    mov rsp, rbp
    pop rbp
    ret 2

readChar: ;(dest: char* in rdi) => char in [rdi]
    mov rax, 3 ;read
    mov rbx, 1 ;stdin
    mov rcx, rdi ;dest
    mov rdx, 1 ;length
    int 80h
    ret

print: ;(string: char* in rcx) => void
    push rbp
    mov rbp, rsp

    push rcx
    call lengthOf
    mov rdx, rax ;length
    mov rax, 4 ;write
    mov rbx, 1 ;stdout
    int 0x80

    mov rsp, rbp
    pop rbp
    ret

string2int: ;(string: char* in rax): => number: int in rbx
push rbp
mov rbp, rsp

mov rsp, rbp
pop rbp

concat: ;(string: char* on stack, string2: char* on stack, dest: char* in rdi) => concatenatedString: string in [dest]
    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]
    mov rdx, [rbp + 16]
    push rdx
    call lengthOf
    mov rcx, rax
    rep movsb

    mov rsi, [rbp + 24]
    mov rdx, [rbp + 24]
    push rdx
    call lengthOf
    mov rcx, rax
    rep movsb

    mov rsp, rbp
    pop rbp
    ret 16

lengthOf: ;(string: char* on stack) => length: int in rax
    push rbp
    mov rbp, rsp

    mov rbx, [rbp + 16]
  lengthLoop:
    cmp [rbx], byte 0
    je exitLengthLoop
    inc rbx
    jmp lengthLoop
  exitLengthLoop:
    mov rax, rbx
    sub rax, [rbp + 16]

    mov rsp, rbp
    pop rbp
    ret 8
