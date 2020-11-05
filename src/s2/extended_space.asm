jmp EnterProtectedMode

%include "s2/gdt.asm"

EnterProtectedMode:
    call EnableA20
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp codeseg:StartProtectedMode

EnableA20:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

[bits 32]

%include "s2/cpu_id.asm"
%include "s2/simple_paging.asm"

StartProtectedMode:
    mov ax, dataseg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call DetectCPUID
    call DetectLongMode
    call SetUpIdentityPaging
    call EditGDT


    jmp codeseg:Start64Bit
    jmp $

[bits 64]
[extern _start]
Start64Bit:
    mov edi, 0xb8000
    mov rax, 0x1f201f201f201f20
    mov ecx, 500
    rep stosq
    call _start
    jmp $

section .data
    enabling_32bit db 'Enabling 32 Bit Mode', 10, 13, 0
    working db 'it works', 10, 13, 0

times 2048-($-$$) db 0