;@author Jaca777
;fastcall, right-to-left

    global main

segment .data
    startMsg db " === Welcome to asmirc! === ", 0xA, " = Enter your name: ", 0
    serverMsg db " = Enter server name: ", 0
    portMsg db " = Enter port: ", 0
    connectMsg db " Connecting to ", 0
    nickTerminator db 0xA

segment .bss
    nick: resb 32 ; 32 chars
    server: resb 64 ; 64 chars
    port: resb 16 ; 16 chars


segment .text

main:
    mov rcx, startMsg
    call print
    push word [nickTerminator]
    mov rdi, nick
    call readString
    push connectMsg
    push nick
    sub rsp, 64
    lea rdi, [rsp + 64]
    call concat
    lea rcx, [rsp + 64]
    call print

exit:
    mov rax, 1
    int 0x80

readString: ;(terminator: char on stack, destAddress: char* on rdi) => void
    push rbp
    mov rbp, rsp

  readStringLoop:
    call readChar
    mov word bx, [rdi]
    inc rdi
    cmp bx, word [rbp + 16]
    jne readStringLoop
  exitReadStringLoop:
    mov word [rdi], 0x0

    mov rsp, rbp
    pop rbp
    ret

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

concat: ;(string: char* on stack, string2: char* on stack, dest: char* in rdi) => concatenatedString: string in [dest]
    push rbp
    mov rbp, rsp
    sub rsp, 8

    mov rsi, [rbp + 16]
    lea rdx, [rbp + 16]
    push rdx
    call lengthOf
    mov rcx, rax
    rep movsb

    mov rsi, [rbp + 24]
    lea rdx, [rbp + 24]
    push rdx
    call lengthOf
    mov rcx, rax
    rep movsb

    mov rsp, rbp
    pop rbp
    ret 8

lengthOf: ;(string: char* on stack) => length: int in rax
    push rbp
    mov rbp, rsp

    mov rbx, [rbp + 16]
  lengthLoop:
    cmp [rbx], word 0
    je exitLengthLoop
    inc rbx
    jmp lengthLoop
  exitLengthLoop:
    mov rax, rbx
    sub rax, [rbp + 16]

    mov rsp, rbp
    pop rbp
    ret
