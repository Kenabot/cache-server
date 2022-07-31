#serial 13

AU_ALIAS([MP_WITH_CURSES], [AX_WITH_CURSES])
AC_DEFUN([AX_WITH_CURSES], [
    AC_ARG_VAR([CURSES_LIB], [linker library for Curses, e.g. -lcurses])
    AC_ARG_WITH([ncurses], [AS_HELP_STRING([--with-ncurses],
        [force the use of Ncurses or NcursesW])],
        [], [with_ncurses=check])
    AC_ARG_WITH([ncursesw], [AS_HELP_STRING([--without-ncursesw],
        [do not use NcursesW (wide character support)])],
        [], [with_ncursesw=check])

    ax_saved_LIBS=$LIBS
    AS_IF([test "x$with_ncurses" = xyes || test "x$with_ncursesw" = xyes],
        [ax_with_plaincurses=no], [ax_with_plaincurses=check])

    ax_cv_curses_which=no

    # Test for NcursesW

    AS_IF([test "x$CURSES_LIB" = x && test "x$with_ncursesw" != xno], [
        LIBS="$ax_saved_LIBS -lncursesw"

        AC_CACHE_CHECK([for NcursesW wide-character library], [ax_cv_ncursesw], [
            AC_LINK_IFELSE([AC_LANG_CALL([], [initscr])],
                [ax_cv_ncursesw=yes], [ax_cv_ncursesw=no])
        ])
        AS_IF([test "x$ax_cv_ncursesw" = xno && test "x$with_ncursesw" = xyes], [
            AC_MSG_ERROR([--with-ncursesw specified but could not find NcursesW library])
        ])

        AS_IF([test "x$ax_cv_ncursesw" = xyes], [
            ax_cv_curses=yes
            ax_cv_curses_which=ncursesw
            CURSES_LIB="-lncursesw"
            AC_DEFINE([HAVE_NCURSESW], [1], [Define to 1 if the NcursesW library is present])
            AC_DEFINE([HAVE_CURSES],   [1], [Define to 1 if a SysV or X/Open compatible Curses library is present])

            AC_CACHE_CHECK([for working ncursesw/curses.h], [ax_cv_header_ncursesw_curses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <ncursesw/curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        attr_t d = WA_NORMAL;
                        cchar_t e;
                        wint_t f;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                        wattr_set(stdscr, d, 0, NULL);
                        wget_wch(stdscr, &f);
                    ]])],
                    [ax_cv_header_ncursesw_curses_h=yes],
                    [ax_cv_header_ncursesw_curses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncursesw_curses_h" = xyes], [
                ax_cv_curses_enhanced=yes
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_ENHANCED],   [1], [Define to 1 if library supports X/Open Enhanced functions])
                AC_DEFINE([HAVE_CURSES_COLOR],      [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE],   [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSESW_CURSES_H], [1], [Define to 1 if <ncursesw/curses.h> is present])
            ])

            AC_CACHE_CHECK([for working ncursesw.h], [ax_cv_header_ncursesw_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <ncursesw.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        attr_t d = WA_NORMAL;
                        cchar_t e;
                        wint_t f;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                        wattr_set(stdscr, d, 0, NULL);
                        wget_wch(stdscr, &f);
                    ]])],
                    [ax_cv_header_ncursesw_h=yes],
                    [ax_cv_header_ncursesw_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncursesw_h" = xyes], [
                ax_cv_curses_enhanced=yes
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_ENHANCED], [1], [Define to 1 if library supports X/Open Enhanced functions])
                AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSESW_H],      [1], [Define to 1 if <ncursesw.h> is present])
            ])

            AC_CACHE_CHECK([for working ncurses.h], [ax_cv_header_ncurses_h_with_ncursesw], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <ncurses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        attr_t d = WA_NORMAL;
                        cchar_t e;
                        wint_t f;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                        wattr_set(stdscr, d, 0, NULL);
                        wget_wch(stdscr, &f);
                    ]])],
                    [ax_cv_header_ncurses_h_with_ncursesw=yes],
                    [ax_cv_header_ncurses_h_with_ncursesw=no])
            ])
            AS_IF([test "x$ax_cv_header_ncurses_h_with_ncursesw" = xyes], [
                ax_cv_curses_enhanced=yes
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_ENHANCED], [1], [Define to 1 if library supports X/Open Enhanced functions])
                AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSES_H],       [1], [Define to 1 if <ncurses.h> is present])
            ])

            AS_IF([test "x$ax_cv_header_ncursesw_curses_h" = xno && test "x$ax_cv_header_ncursesw_h" = xno && test "x$ax_cv_header_ncurses_h_with_ncursesw" = xno], [
                AC_MSG_WARN([could not find a working ncursesw/curses.h, ncursesw.h or ncurses.h])
            ])
        ])
    ])

    # Test for Ncurses

    AS_IF([test "x$CURSES_LIB" = x && test "x$with_ncurses" != xno && test "x$ax_cv_curses_which" = xno], [
        LIBS="$ax_saved_LIBS -lncurses"

        AC_CACHE_CHECK([for Ncurses library], [ax_cv_ncurses], [
            AC_LINK_IFELSE([AC_LANG_CALL([], [initscr])],
                [ax_cv_ncurses=yes], [ax_cv_ncurses=no])
        ])
        AS_IF([test "x$ax_cv_ncurses" = xno && test "x$with_ncurses" = xyes], [
            AC_MSG_ERROR([--with-ncurses specified but could not find Ncurses library])
        ])

        AS_IF([test "x$ax_cv_ncurses" = xyes], [
            ax_cv_curses=yes
            ax_cv_curses_which=ncurses
            CURSES_LIB="-lncurses"
            AC_DEFINE([HAVE_NCURSES], [1], [Define to 1 if the Ncurses library is present])
            AC_DEFINE([HAVE_CURSES],  [1], [Define to 1 if a SysV or X/Open compatible Curses library is present])

            AC_CACHE_CHECK([for working ncurses/curses.h], [ax_cv_header_ncurses_curses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <ncurses/curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                    ]])],
                    [ax_cv_header_ncurses_curses_h=yes],
                    [ax_cv_header_ncurses_curses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncurses_curses_h" = xyes], [
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_COLOR],     [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE],  [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSES_CURSES_H], [1], [Define to 1 if <ncurses/curses.h> is present])
            ])

            AC_CACHE_CHECK([for working ncurses.h], [ax_cv_header_ncurses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <ncurses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        chtype c = COLOR_PAIR(1) & A_COLOR;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                        init_pair(1, COLOR_WHITE, COLOR_RED);
                    ]])],
                    [ax_cv_header_ncurses_h=yes],
                    [ax_cv_header_ncurses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_ncurses_h" = xyes], [
                ax_cv_curses_color=yes
                ax_cv_curses_obsolete=yes
                AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                AC_DEFINE([HAVE_NCURSES_H],       [1], [Define to 1 if <ncurses.h> is present])
            ])

            AS_IF([test "x$ax_cv_header_ncurses_curses_h" = xno && test "x$ax_cv_header_ncurses_h" = xno], [
                AC_MSG_WARN([could not find a working ncurses/curses.h or ncurses.h])
            ])
        ])
    ])

    # Test for plain Curses (or if CURSES_LIB was set by user)

    AS_IF([test "x$with_plaincurses" != xno && test "x$ax_cv_curses_which" = xno], [
        AS_IF([test "x$CURSES_LIB" != x], [
            LIBS="$ax_saved_LIBS $CURSES_LIB"
        ], [
            LIBS="$ax_saved_LIBS -lcurses"
        ])

        AC_CACHE_CHECK([for Curses library], [ax_cv_plaincurses], [
            AC_LINK_IFELSE([AC_LANG_CALL([], [initscr])],
                [ax_cv_plaincurses=yes], [ax_cv_plaincurses=no])
        ])

        AS_IF([test "x$ax_cv_plaincurses" = xyes], [
            ax_cv_curses=yes
            ax_cv_curses_which=plaincurses
            AS_IF([test "x$CURSES_LIB" = x], [
                CURSES_LIB="-lcurses"
            ])
            AC_DEFINE([HAVE_CURSES], [1], [Define to 1 if a SysV or X/Open compatible Curses library is present])

            # Check for base conformance (and header file)

            AC_CACHE_CHECK([for working curses.h], [ax_cv_header_curses_h], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        initscr();
                    ]])],
                    [ax_cv_header_curses_h=yes],
                    [ax_cv_header_curses_h=no])
            ])
            AS_IF([test "x$ax_cv_header_curses_h" = xyes], [
                AC_DEFINE([HAVE_CURSES_H], [1], [Define to 1 if <curses.h> is present])

                # Check for X/Open Enhanced conformance

                AC_CACHE_CHECK([for X/Open Enhanced Curses conformance], [ax_cv_plaincurses_enhanced], [
                    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                            @%:@define _XOPEN_SOURCE_EXTENDED 1
                            @%:@include <curses.h>
                            @%:@ifndef _XOPEN_CURSES
                            @%:@error "this Curses library is not enhanced"
                            "this Curses library is not enhanced"
                            @%:@endif
                        ]], [[
                            chtype a = A_BOLD;
                            int b = KEY_LEFT;
                            chtype c = COLOR_PAIR(1) & A_COLOR;
                            attr_t d = WA_NORMAL;
                            cchar_t e;
                            wint_t f;
                            initscr();
                            init_pair(1, COLOR_WHITE, COLOR_RED);
                            wattr_set(stdscr, d, 0, NULL);
                            wget_wch(stdscr, &f);
                        ]])],
                        [ax_cv_plaincurses_enhanced=yes],
                        [ax_cv_plaincurses_enhanced=no])
                ])
                AS_IF([test "x$ax_cv_plaincurses_enhanced" = xyes], [
                    ax_cv_curses_enhanced=yes
                    ax_cv_curses_color=yes
                    AC_DEFINE([HAVE_CURSES_ENHANCED], [1], [Define to 1 if library supports X/Open Enhanced functions])
                    AC_DEFINE([HAVE_CURSES_COLOR],    [1], [Define to 1 if library supports color (enhanced functions)])
                ])

                # Check for color functions

                AC_CACHE_CHECK([for Curses color functions], [ax_cv_plaincurses_color], [
                    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@define _XOPEN_SOURCE_EXTENDED 1
                        @%:@include <curses.h>
                        ]], [[
                            chtype a = A_BOLD;
                            int b = KEY_LEFT;
                            chtype c = COLOR_PAIR(1) & A_COLOR;
                            initscr();
                            init_pair(1, COLOR_WHITE, COLOR_RED);
                        ]])],
                        [ax_cv_plaincurses_color=yes],
                        [ax_cv_plaincurses_color=no])
                ])
                AS_IF([test "x$ax_cv_plaincurses_color" = xyes], [
                    ax_cv_curses_color=yes
                    AC_DEFINE([HAVE_CURSES_COLOR], [1], [Define to 1 if library supports color (enhanced functions)])
                ])

                # Check for obsolete functions

                AC_CACHE_CHECK([for obsolete Curses functions], [ax_cv_plaincurses_obsolete], [
                AC_LINK_IFELSE([AC_LANG_PROGRAM([[
                        @%:@include <curses.h>
                    ]], [[
                        chtype a = A_BOLD;
                        int b = KEY_LEFT;
                        int g = getattrs(stdscr);
                        int h = getcurx(stdscr) + getmaxx(stdscr);
                        initscr();
                    ]])],
                    [ax_cv_plaincurses_obsolete=yes],
                    [ax_cv_plaincurses_obsolete=no])
                ])
                AS_IF([test "x$ax_cv_plaincurses_obsolete" = xyes], [
                    ax_cv_curses_obsolete=yes
                    AC_DEFINE([HAVE_CURSES_OBSOLETE], [1], [Define to 1 if library supports certain obsolete features])
                ])
            ])

            AS_IF([test "x$ax_cv_header_curses_h" = xno], [
                AC_MSG_WARN([could not find a working curses.h])
            ])
        ])
    ])

    AS_IF([test "x$ax_cv_curses"          != xyes], [ax_cv_curses=no])
    AS_IF([test "x$ax_cv_curses_enhanced" != xyes], [ax_cv_curses_enhanced=no])
    AS_IF([test "x$ax_cv_curses_color"    != xyes], [ax_cv_curses_color=no])
    AS_IF([test "x$ax_cv_curses_obsolete" != xyes], [ax_cv_curses_obsolete=no])

    LIBS=$ax_saved_LIBS
])dnl
