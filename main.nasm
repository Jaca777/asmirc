;@author Jaca777
;fastcall, right-to-left

    global main
    extern readString
    extern print
    extern concat
    extern string2int

segment .data
    startMsg db " === Welcome to asmirc! === ", 0xA, "  = Enter your name: ", 0
    serverMsg db "  = Enter server name: ", 0
    portMsg db "  = Enter port: ", 0
    connectMsg db "  = Connecting to ", 0
    inputTerminator db 0xA

segment .bss
    nick: resb 32 ; 32 chars
    server: resb 48 ; 48 chars
    port: resd 1 ; int
    connectMsgCon: resb 65 ; 65 chars


segment .text

main:
    mov rcx, startMsg ; start msg
    call print

    push word [inputTerminator] ; reading nick
    mov rdi, nick
    call readString

    mov rcx, serverMsg ; reading server
    call print
    push word [inputTerminator]
    mov rdi, server
    call readString

    sub rsp, 8 ; reading port
    mov rcx, portMsg
    call print
    push word [inputTerminator]
    mov rdi, rsp
    call readString
    mov rsi, rsp
    call string2int
    add rsp, 8
    mov [port], rbx

    push port
    push connectMsg
    mov rdi, connectMsgCon
    call concat
    mov rcx, connectMsgCon
    call print



exit:
    mov rax, 1
    int 0x80
