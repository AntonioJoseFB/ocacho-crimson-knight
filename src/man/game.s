;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GLOBL INCLUDES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Cpctelera video functions
.globl cpct_waitVSYNC_asm
.globl cpct_memcpy_asm

;;Managers
.globl man_entity_init
.globl man_entity_update
.globl man_entity_create

;;Systems
.globl sys_physics_update
.globl sys_render_init
.globl sys_render_update
.globl sys_ai_update

;;Entity variables
.globl entity_size

;Math utilities
.globl inc_hl_number
.globl inc_de_number
.globl dec_hl_number
.globl dec_de_number


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MACROS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Macro for creation of entity templates _
.macro DEFINE_ENTITY_TEMPLATE _name, _type, _pos_x, _pos_y, _width, _height, _vel_x, _vel_y, _sprite
_name:
    .db _type           ; type -> e_type_movable | e_type_render | e_type_ai
    .db _pos_x          ; pos_x
    .db _pos_y          ; pos_y
    .db _width          ; width  ;; TODO: This should change using the variables of sprites
    .db _height         ; height  ;; TODO: This should change using the variables of sprites
    .db _vel_x          ; vel_x
    .db _vel_y          ; vel_y
    .dw _sprite         ; sprite TODO: We should include the sprite generated and change this
.endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
m_sprite_player:
        .db #0x00, #0x00, #0x00, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0xFF, #0xFF, #0x00
        .db #0x00, #0x00, #0x00, #0x00

m_sprite_enemy:
        .db #0x00, #0x00, #0x00, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0x00
        .db #0x00, #0x00, #0x00, #0x00


m_sprite_arrow:
        .db #0x00, #0x00, #0x00, #0x00, #0x00
        .db #0x00, #0xF0, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0xF0, #0x00
        .db #0x00, #0xF0, #0xF0, #0xF0, #0x00
        .db #0x00, #0x00, #0x00, #0x00, #0x00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEMPLATES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DEFINE_ENTITY_TEMPLATE player_tmpl,           #7, #10, #180, #4, #10, 0, 0, m_sprite_player
DEFINE_ENTITY_TEMPLATE enemy_tmpl,           #7, #10, #180, #4, #10, 0, 0, m_sprite_enemy
DEFINE_ENTITY_TEMPLATE arrow_tmpl,           #7, #10, #180, #4, #10, 0, 0, m_sprite_arrow


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

man_game_init::
    call man_entity_init
	call sys_render_init
    ;;Once our sprite is set up, create the entities

    ;;Mothership
    ld hl, #player_tmpl
    call man_game_create_template_entity

ret
man_game_play::
    game_loop:

    ;;call sys_ai_update
	;;call sys_physics_update
	call sys_render_update
	;;call man_entity_update
	call cpct_waitVSYNC_asm

    jr game_loop
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pre requirements
;;  - HL: should contain the memory direction for the template to by created
;; Objetive: Creates an entity given a template
;; Modifies: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
man_game_create_template_entity:

    push hl

    call man_entity_create

    pop hl

    ;;HL contains the template, DE conntais the memory direction and BC the size
    ld bc, #entity_size

    ;;We want to keep the value of DE
    push de

    call cpct_memcpy_asm

    pop de
ret