AC_DEFUN([gl_LD_VERSION_SCRIPT],
[
  AC_ARG_ENABLE([ld-version-script],
    AS_HELP_STRING([--enable-ld-version-script],
      [enable linker version script (default is enabled when possible)]),
      [have_ld_version_script=$enableval], [])
  if test -z "$have_ld_version_script"; then
    AC_MSG_CHECKING([if LD -Wl,--version-script works])
    save_LDFLAGS="$LDFLAGS"
    LDFLAGS="$LDFLAGS -Wl,--version-script=conftest.map"
    cat > conftest.map <<EOF
foo
EOF
    AC_LINK_IFELSE([AC_LANG_PROGRAM([], [])],
                   [accepts_syntax_errors=yes], [accepts_syntax_errors=no])
    if test "$accepts_syntax_errors" = no; then
      cat > conftest.map <<EOF
VERS_1 {
        global: sym;
};

VERS_2 {
        global: sym;
} VERS_1;
EOF
      AC_LINK_IFELSE([AC_LANG_PROGRAM([], [])],
                     [have_ld_version_script=yes], [have_ld_version_script=no])
    else
      have_ld_version_script=no
    fi
    rm -f conftest.map
    LDFLAGS="$save_LDFLAGS"
    AC_MSG_RESULT($have_ld_version_script)
  fi
  AM_CONDITIONAL(HAVE_LD_VERSION_SCRIPT, test "$have_ld_version_script" = "yes")
])
