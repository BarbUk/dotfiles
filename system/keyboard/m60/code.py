from PYKB import *

keyboard = Keyboard()

___ = TRANSPARENT
BOOT = BOOTLOADER
L1 = LAYER_TAP(1)
L2 = LAYER_TAP(2)
L3 = LAYER_TAP(3)

PRINT = PRINTSCREEN

MUTE = AUDIO_MUTE
VOLU = AUDIO_VOL_UP
VOLD = AUDIO_VOL_DOWN
NEXT = TRANSPORT_NEXT_TRACK
PREV = TRANSPORT_PREV_TRACK
STOP = TRANSPORT_STOP
PLAY = TRANSPORT_PLAY_PAUSE

keyboard.keymap = (
    # layer 0
    (
        ESC,   1,   2,   3,   4,   5,   6,   7,   8,   9,   0, '-', '=', BACKSPACE,
        TAB,   Q,   W,   E,   R,   T,   Y,   U,   I,   O,   P, '[', ']', '|',
        L1 ,   A,   S,   D,   F,   G,   H,   J,   K,   L, ';', '"',    ENTER,
        LSHIFT, Z,   X,   C,   V, B,   N,   M, ',', '.', '/',         RSHIFT,
        LCTRL, LGUI, LALT,          SPACE,            RALT, MENU,  L2, RCTRL
    ),

    # layer 1
    (
        '`',   F1,   F2,   F3,  F4,  F5,  F6,   F7,  F8,   F9,   F10, F11, F12, DEL,
        L3 , PREV, PLAY, NEXT, ___, ___, ___, PGUP,  UP, PGDN, PRINT, ___, ___, ___,
        ___, VOLD, MUTE, VOLU, ___, ___, HOME, LEFT, DOWN, RIGHT, ___, ___, ___,
        ___,  ___,  ___,  ___, ___, ___,  END,  ___,  ___,   ___, ___,      ___,
        ___,  ___,  ___,                ___,               ___, ___, ___,  ___
    ),

     # layer 2
    (
        BT_TOGGLE,BT1,BT2, BT3,BT4,BT5,BT6,BT7, BT8, BT9, BT0, ___, ___, SUSPEND,
        RGB_MOD, ___, ___, ___, ___, ___,___,USB_TOGGLE,___,___,___,___,___, ___,
        RGB_TOGGLE,HUE_RGB,RGB_HUE,SAT_RGB,RGB_SAT,___,___,___,___,___,___,___,      SHUTDOWN,
        ___, ___, ___, ___, ___, BOOT, ___, ___,VAL_RGB,RGB_VAL, ___,           ___,
        ___, ___, ___,                ___,               ___, ___, ___,  ___
    ),

    # layer 3
    (
        ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___, ___,
        ___, ___, ___, ___, ___, ___,MS_W_UP,MS_UL,MS_UP,MS_UR, ___, ___, ___, ___,
        ___, ___, ___, ___, ___, ___,MS_BTN1,MS_LT,MS_DN,MS_RT,MS_BTN2, ___,      ___,
        ___, ___, ___, ___, ___, ___,MS_W_DN,MS_DL,MS_DN,MS_DR, ___,           ___,
        ___, ___, ___,                ___,               ___, ___, ___,  ___
    ),
)


def macro_handler(dev, n, is_down):
    if is_down:
        dev.send_text('You pressed macro #{}\n'.format(n))
    else:
        dev.send_text('You released macro #{}\n'.format(n))

def pairs_handler(dev, n):
    if n == 0:
        dev.kbd.log('Power-off pair key detected\n')
        microcontroller.reset()
    elif n == 1:
        dev.kbd.log('Remount storage read-write\n')
        storage.remount('/', 1)
    elif n == 2:
        log('Remount storage read-only\n')
        storage.remount('/', 0)
    else:
        dev.kbd.log('You just triggered pair keys #{}\n'.format(n))


keyboard.macro_handler = macro_handler
#keyboard.pairs_handler = pairs_handler

# ESC(0)    1(1)   2(2)   3(3)   4(4)   5(5)   6(6)   7(7)   8(8)   9(9)   0(10)  -(11)  =(12)  BACKSPACE(13)
# TAB(27)   Q(26)  W(25)  E(24)  R(23)  T(22)  Y(21)  U(20)  I(19)  O(18)  P(17)  [(16)  ](15)   \(14)
# CAPS(28)  A(29)  S(30)  D(31)  F(32)  G(33)  H(34)  J(35)  K(36)  L(37)  ;(38)  "(39)      ENTER(40)
#LSHIFT(52) Z(51)  X(50)  C(49)  V(48)  B(47)  N(46)  M(45)  ,(44)  .(43)  /(42)            RSHIFT(41)
# LCTRL(53)  LGUI(54)  LALT(55)               SPACE(56)          RALT(57)  MENU(58)  Fn(59)  RCTRL(60)

# Pairs: J & K, U & I
keyboard.pairs = [
    {0, 40}, #0 ESC+ENTER       Poweroff
    {0, 13}, #1 ESC+BACKSPACE   Remount RW
    {0, 53}  #2 ESC+LCTRL       Remount RO
]

# cat /dev/ttyACM0
keyboard.verbose = False

keyboard.matrix.debounce_time = 5
keyboard.tap_delay = 50
keyboard.fast_type_thresh = 30

keyboard.run()
