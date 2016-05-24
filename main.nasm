;@author Jaca777
;fastcall, right-to-left

    global main
    extern readString
    extern print
    extern concat

segment .data
    startMsg db " === Welcome to asmirc! === ", 0xA, "  = Enter your name: ", 0
    serverMsg db "  = Enter server name: ", 0
    portMsg db "  = Enter port: ", 0
    connectMsg db "  = Connecting to ", 0
    nickTerminator db 0xA

segment .bss
    nick: resb 32 ; 32 chars
    server: resb 48 ; 48 chars
    port: resd 1 ; int
    connectMsgCon: resb 65 ; 65 chars


segment .text

main:
    mov rcx, startMsg
    call print
    push word [nickTerminator]
    mov rdi, nick
    call readString
    mov rcx, serverMsg
    call print
    push word [nickTerminator]
    mov rdi, server
    call readString
    push server
    push connectMsg
    mov rdi, connectMsgCon
    call concat
    mov rcx, connectMsgCon
    call print



exit:
    mov rax, 1
    int 0x80
