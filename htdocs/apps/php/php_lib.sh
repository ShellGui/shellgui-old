#!/bin/sh

install_php_dependence()
{
if
echo "$OS" | grep -iq "centos"
then
(yum update -y && yum install -y libxml2-devel libcurl-devel 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "ubuntu"
then
(apt-get update --fix-missing && apt-get install -y libxml2-dev libcurl4-openssl-dev 2>&1) || exit 1
fi
if
echo "$OS" | grep -iq "debian"
then
(apt-get update --fix-missing && apt-get install -y libxml2-dev libcurl4-openssl-dev 2>&1) || exit 1
fi
}

download_php()
{
# jpegsrc.v9.tar.gz
export download_json='{
"file_name":"jpegsrc.v9.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/jpegsrc.v9.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"b397211ddfd506b92cd5e02a22ac924d",
	"download_urls":{
	"misc":"http://fossies.org/linux/misc/jpegsrc.v9.tar.gz",
	"ijg":"http://www.ijg.org/files/jpegsrc.v9.tar.gz",
	"debian":"ftp://ftp2.de.debian.org/fink-distfiles/jpegsrc.v9.tar.gz",
	"videolan":"http://download.videolan.org/contrib/jpegsrc.v9.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/jpegsrc.v9.tar.gz | awk {'print $1'})" != "b397211ddfd506b92cd5e02a22ac924d" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/jpegsrc.v9.tar.gz
# aria2c http://fossies.org/linux/misc/jpegsrc.v9.tar.gz \
# http://www.ijg.org/files/jpegsrc.v9.tar.gz \
# ftp://ftp2.de.debian.org/fink-distfiles/jpegsrc.v9.tar.gz \
# http://download.videolan.org/contrib/jpegsrc.v9.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libpng-1.6.3.tar.gz
export download_json='{
"file_name":"libpng-1.6.3.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libpng-1.6.3.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"98b652b6c174c35148f1f5f513fe490d",
	"download_urls":{
	"sourceforge":"http://prdownloads.sourceforge.net/libpng/libpng-1.6.3.tar.gz",
	"u-aizu":"ftp://ftp.u-aizu.ac.jp/pub/graphics/image/ImageMagick/simplesystems.org/libpng/png/src/history/libpng16/libpng-1.6.3.tar.gz"
	}
}'
main.sbin download

# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libpng-1.6.3.tar.gz | awk {'print $1'})" != "98b652b6c174c35148f1f5f513fe490d" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libpng-1.6.3.tar.gz
# aria2c http://prdownloads.sourceforge.net/libpng/libpng-1.6.3.tar.gz \
# ftp://ftp.u-aizu.ac.jp/pub/graphics/image/ImageMagick/simplesystems.org/libpng/png/src/history/libpng16/libpng-1.6.3.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# freetype-2.4.12.tar.gz
export download_json='{
"file_name":"freetype-2.4.12.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/freetype-2.4.12.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"e3057079a9bb96d7ebf9afee3f724653",
	"download_urls":{
	"askapache":"http://nongnu.askapache.com/freetype/freetype-2.4.12.tar.gz",
	"savannah":"http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/freetype-2.4.12.tar.gz | awk {'print $1'})" != "e3057079a9bb96d7ebf9afee3f724653" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/freetype-2.4.12.tar.gz
# aria2c http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.gz \
# http://nongnu.askapache.com/freetype/freetype-2.4.12.tar.gz \
# http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# mhash-0.9.9.9.tar.gz
export download_json='{
"file_name":"mhash-0.9.9.9.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/mhash-0.9.9.9.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"ee66b7d5947deb760aeff3f028e27d25",
	"download_urls":{
	"sourceforge":"http://nchc.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz",
	"sourceforge":"http://superb-dca2.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz",
	"vpser":"http://soft.vpser.net/web/mhash/mhash-0.9.9.9.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/mhash-0.9.9.9.tar.gz | awk {'print $1'})" != "ee66b7d5947deb760aeff3f028e27d25" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/mhash-0.9.9.9.tar.gz
# aria2c http://nchc.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
# http://superb-dca2.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz \
# http://soft.vpser.net/web/mhash/mhash-0.9.9.9.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libmcrypt-2.5.8.tar.gz
export download_json='{
"file_name":"libmcrypt-2.5.8.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libmcrypt-2.5.8.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"0821830d930a86a5c69110837c55b7da",
	"download_urls":{
	"sourceforge":"http://softlayer.dl.sourceforge.net/sourceforge/mcrypt/libmcrypt-2.5.8.tar.gz",
	"sourceforge":"http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz",
	"sourceforge":"http://softlayer-dal.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libmcrypt-2.5.8.tar.gz | awk {'print $1'})" != "0821830d930a86a5c69110837c55b7da" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libmcrypt-2.5.8.tar.gz
# aria2c http://softlayer.dl.sourceforge.net/sourceforge/mcrypt/libmcrypt-2.5.8.tar.gz \
# http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz \
# http://softlayer-dal.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libevent-2.0.21-stable.tar.gz
export download_json='{
"file_name":"libevent-2.0.21-stable.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libevent-2.0.21-stable.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"b2405cc9ebf264aa47ff615d9de527a2",
	"download_urls":{
	"github":"http://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz",
	"netbsd":"ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/libevent-2.0.21-stable.tar.gz",
	"github":"https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libevent-2.0.21-stable.tar.gz | awk {'print $1'})" != "b2405cc9ebf264aa47ff615d9de527a2" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libevent-2.0.21-stable.tar.gz
# aria2c http://cloud.github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz \
# ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/libevent-2.0.21-stable.tar.gz \
# https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# libiconv-1.14.tar.gz
export download_json='{
"file_name":"libiconv-1.14.tar.gz",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/libiconv-1.14.tar.gz",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"e34509b1623cec449dfeb73d7ce9c6c6",
	"download_urls":{
	"gnu.org":"http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz",
	"anl.gov":"http://mirror.anl.gov/pub/gnu/libiconv/libiconv-1.14.tar.gz",
	"jp":"http://ftp.yz.yamagata-u.ac.jp/pub/GNU/libiconv/libiconv-1.14.tar.gz"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/libiconv-1.14.tar.gz | awk {'print $1'})" != "e34509b1623cec449dfeb73d7ce9c6c6" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/libiconv-1.14.tar.gz
# aria2c http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
# http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz \
# http://mirror.anl.gov/pub/gnu/libiconv/libiconv-1.14.tar.gz \
# http://ftp.yz.yamagata-u.ac.jp/pub/GNU/libiconv/libiconv-1.14.tar.gz --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi

# php-5.5.16.tar.bz2
export download_json='{
"file_name":"php-5.5.16.tar.bz2",
"downloader":"aria2 curl wget",
"save_dest":"$DOCUMENT_ROOT/../sources/php-5.5.16.tar.bz2",
"useragent":"Mozilla/4.0 (compatible; MSIE 6.1; Windows XP)",
"timeout":20,
"md5sum":"331a87fb27e100a88b3845d34582f769",
	"download_urls":{
	"php":"http://jp1.php.net/distributions/php-5.5.16.tar.bz2",
	"sohu":"http://mirrors.sohu.com/php/php-5.5.16.tar.bz2",
	"internode":"http://mirror.internode.on.net/pub/php/php-5.5.16.tar.bz2"
	}
}'
main.sbin download
# if
# [ "$(md5sum $DOCUMENT_ROOT/../sources/php-5.5.16.tar.bz2 | awk {'print $1'})" != "331a87fb27e100a88b3845d34582f769" ]
# then
# rm -f $DOCUMENT_ROOT/../sources/php-5.5.16.tar.bz2
# aria2c http://jp1.php.net/distributions/php-5.5.16.tar.bz2 \
# http://mirrors.sohu.com/php/php-5.5.16.tar.bz2 \
# http://mirror.internode.on.net/pub/php/php-5.5.16.tar.bz2 --dir=$DOCUMENT_ROOT/../sources/ 2>&1
# fi
}

make_php()
{
# jpegsrc.v9.tar.gz
# libpng-1.6.3.tar.gz
# freetype-2.4.12.tar.gz
# mhash-0.9.9.9.tar.gz
# libmcrypt-2.5.8.tar.gz
# libevent-2.0.21-stable.tar.gz
# libiconv-1.14.tar.gz
# php-5.5.16.tar.bz2

cd $DOCUMENT_ROOT/../sources/
rm -rf jpegsrc.v9
tar zxvf jpegsrc.v9.tar.gz
rm -rf libpng-1.6.3
tar zxvf libpng-1.6.3.tar.gz
rm -rf freetype-2.4.12
tar zxvf freetype-2.4.12.tar.gz
rm -rf mhash-0.9.9.9
tar zxvf mhash-0.9.9.9.tar.gz
rm -rf libmcrypt-2.5.8
tar zxvf libmcrypt-2.5.8.tar.gz
rm -rf libevent-2.0.21-stable
tar zxvf libevent-2.0.21-stable.tar.gz
rm -rf libiconv-1.14
tar zxvf libiconv-1.14.tar.gz
rm -rf php-5.5.16
tar jxvf php-5.5.16.tar.bz2

cd $DOCUMENT_ROOT/../sources/jpeg-9
./configure --prefix=/usr/local/phpextend --enable-shared --enable-static
make && make install
cd $DOCUMENT_ROOT/../sources/libpng-1.6.3
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/freetype-2.4.12
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/mhash-0.9.9.9
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/libmcrypt-2.5.8
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/libevent-2.0.21-stable
./configure --prefix=/usr/local/phpextend
make && make install
cd $DOCUMENT_ROOT/../sources/libiconv-1.14
./configure --prefix=/usr/local/phpextend
echo "$distribution" | grep -iq "centos-7" && sed -i '/gets is a security hole/d' $DOCUMENT_ROOT/../sources/libiconv-1.14/srclib/stdio.h
make && make install
if
[ $? -ne 0 ]
then
cat <<'EOF' > srclib/stdio.in.h
/* A GNU-like <stdio.h>.

   Copyright (C) 2004, 2007-2011 Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

#if __GNUC__ >= 3
@PRAGMA_SYSTEM_HEADER@
#endif
@PRAGMA_COLUMNS@

#if defined __need_FILE || defined __need___FILE || defined _GL_ALREADY_INCLUDING_STDIO_H
/* Special invocation convention:
   - Inside glibc header files.
   - On OSF/1 5.1 we have a sequence of nested includes
     <stdio.h> -> <getopt.h> -> <ctype.h> -> <sys/localedef.h> ->
     <sys/lc_core.h> -> <nl_types.h> -> <mesg.h> -> <stdio.h>.
     In this situation, the functions are not yet declared, therefore we cannot
     provide the C++ aliases.  */

#@INCLUDE_NEXT@ @NEXT_STDIO_H@

#else
/* Normal invocation convention.  */

#ifndef _@GUARD_PREFIX@_STDIO_H

#define _GL_ALREADY_INCLUDING_STDIO_H

/* The include_next requires a split double-inclusion guard.  */
#@INCLUDE_NEXT@ @NEXT_STDIO_H@

#undef _GL_ALREADY_INCLUDING_STDIO_H

#ifndef _@GUARD_PREFIX@_STDIO_H
#define _@GUARD_PREFIX@_STDIO_H

/* Get va_list.  Needed on many systems, including glibc 2.8.  */
#include <stdarg.h>

#include <stddef.h>

/* Get off_t and ssize_t.  Needed on many systems, including glibc 2.8
   and eglibc 2.11.2.  */
#include <sys/types.h>

/* The __attribute__ feature is available in gcc versions 2.5 and later.
   The __-protected variants of the attributes 'format' and 'printf' are
   accepted by gcc versions 2.6.4 (effectively 2.7) and later.
   We enable _GL_ATTRIBUTE_FORMAT only if these are supported too, because
   gnulib and libintl do '#define printf __printf__' when they override
   the 'printf' function.  */
#if __GNUC__ > 2 || (__GNUC__ == 2 && __GNUC_MINOR__ >= 7)
# define _GL_ATTRIBUTE_FORMAT(spec) __attribute__ ((__format__ spec))
#else
# define _GL_ATTRIBUTE_FORMAT(spec) /* empty */
#endif

/* _GL_ATTRIBUTE_FORMAT_PRINTF
   indicates to GCC that the function takes a format string and arguments,
   where the format string directives are the ones standardized by ISO C99
   and POSIX.  */
#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4)
# define _GL_ATTRIBUTE_FORMAT_PRINTF(formatstring_parameter, first_argument) \
   _GL_ATTRIBUTE_FORMAT ((__gnu_printf__, formatstring_parameter, first_argument))
#else
# define _GL_ATTRIBUTE_FORMAT_PRINTF(formatstring_parameter, first_argument) \
   _GL_ATTRIBUTE_FORMAT ((__printf__, formatstring_parameter, first_argument))
#endif

/* _GL_ATTRIBUTE_FORMAT_PRINTF_SYSTEM is like _GL_ATTRIBUTE_FORMAT_PRINTF,
   except that it indicates to GCC that the supported format string directives
   are the ones of the system printf(), rather than the ones standardized by
   ISO C99 and POSIX.  */
#define _GL_ATTRIBUTE_FORMAT_PRINTF_SYSTEM(formatstring_parameter, first_argument) \
  _GL_ATTRIBUTE_FORMAT ((__printf__, formatstring_parameter, first_argument))

/* _GL_ATTRIBUTE_FORMAT_SCANF
   indicates to GCC that the function takes a format string and arguments,
   where the format string directives are the ones standardized by ISO C99
   and POSIX.  */
#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 4)
# define _GL_ATTRIBUTE_FORMAT_SCANF(formatstring_parameter, first_argument) \
   _GL_ATTRIBUTE_FORMAT ((__gnu_scanf__, formatstring_parameter, first_argument))
#else
# define _GL_ATTRIBUTE_FORMAT_SCANF(formatstring_parameter, first_argument) \
   _GL_ATTRIBUTE_FORMAT ((__scanf__, formatstring_parameter, first_argument))
#endif

/* _GL_ATTRIBUTE_FORMAT_SCANF_SYSTEM is like _GL_ATTRIBUTE_FORMAT_SCANF,
   except that it indicates to GCC that the supported format string directives
   are the ones of the system scanf(), rather than the ones standardized by
   ISO C99 and POSIX.  */
#define _GL_ATTRIBUTE_FORMAT_SCANF_SYSTEM(formatstring_parameter, first_argument) \
  _GL_ATTRIBUTE_FORMAT ((__scanf__, formatstring_parameter, first_argument))

/* Solaris 10 declares renameat in <unistd.h>, not in <stdio.h>.  */
/* But in any case avoid namespace pollution on glibc systems.  */
#if (@GNULIB_RENAMEAT@ || defined GNULIB_POSIXCHECK) && defined __sun \
    && ! defined __GLIBC__
# include <unistd.h>
#endif


/* The definitions of _GL_FUNCDECL_RPL etc. are copied here.  */

/* The definition of _GL_ARG_NONNULL is copied here.  */

/* The definition of _GL_WARN_ON_USE is copied here.  */

/* Macros for stringification.  */
#define _GL_STDIO_STRINGIZE(token) #token
#define _GL_STDIO_MACROEXPAND_AND_STRINGIZE(token) _GL_STDIO_STRINGIZE(token)


#if @GNULIB_DPRINTF@
# if @REPLACE_DPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define dprintf rpl_dprintf
#  endif
_GL_FUNCDECL_RPL (dprintf, int, (int fd, const char *format, ...)
                                _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                                _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL (dprintf, int, (int fd, const char *format, ...));
# else
#  if !@HAVE_DPRINTF@
_GL_FUNCDECL_SYS (dprintf, int, (int fd, const char *format, ...)
                                _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                                _GL_ARG_NONNULL ((2)));
#  endif
_GL_CXXALIAS_SYS (dprintf, int, (int fd, const char *format, ...));
# endif
_GL_CXXALIASWARN (dprintf);
#elif defined GNULIB_POSIXCHECK
# undef dprintf
# if HAVE_RAW_DECL_DPRINTF
_GL_WARN_ON_USE (dprintf, "dprintf is unportable - "
                 "use gnulib module dprintf for portability");
# endif
#endif

#if @GNULIB_FCLOSE@
/* Close STREAM and its underlying file descriptor.  */
# if @REPLACE_FCLOSE@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define fclose rpl_fclose
#  endif
_GL_FUNCDECL_RPL (fclose, int, (FILE *stream) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (fclose, int, (FILE *stream));
# else
_GL_CXXALIAS_SYS (fclose, int, (FILE *stream));
# endif
_GL_CXXALIASWARN (fclose);
#elif defined GNULIB_POSIXCHECK
# undef fclose
/* Assume fclose is always declared.  */
_GL_WARN_ON_USE (fclose, "fclose is not always POSIX compliant - "
                 "use gnulib module fclose for portable POSIX compliance");
#endif

#if @GNULIB_FFLUSH@
/* Flush all pending data on STREAM according to POSIX rules.  Both
   output and seekable input streams are supported.
   Note! LOSS OF DATA can occur if fflush is applied on an input stream
   that is _not_seekable_ or on an update stream that is _not_seekable_
   and in which the most recent operation was input.  Seekability can
   be tested with lseek(fileno(fp),0,SEEK_CUR).  */
# if @REPLACE_FFLUSH@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define fflush rpl_fflush
#  endif
_GL_FUNCDECL_RPL (fflush, int, (FILE *gl_stream));
_GL_CXXALIAS_RPL (fflush, int, (FILE *gl_stream));
# else
_GL_CXXALIAS_SYS (fflush, int, (FILE *gl_stream));
# endif
_GL_CXXALIASWARN (fflush);
#elif defined GNULIB_POSIXCHECK
# undef fflush
/* Assume fflush is always declared.  */
_GL_WARN_ON_USE (fflush, "fflush is not always POSIX compliant - "
                 "use gnulib module fflush for portable POSIX compliance");
#endif

#if @GNULIB_FGETC@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fgetc
#   define fgetc rpl_fgetc
#  endif
_GL_FUNCDECL_RPL (fgetc, int, (FILE *stream) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (fgetc, int, (FILE *stream));
# else
_GL_CXXALIAS_SYS (fgetc, int, (FILE *stream));
# endif
_GL_CXXALIASWARN (fgetc);
#endif

#if @GNULIB_FGETS@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fgets
#   define fgets rpl_fgets
#  endif
_GL_FUNCDECL_RPL (fgets, char *, (char *s, int n, FILE *stream)
                                 _GL_ARG_NONNULL ((1, 3)));
_GL_CXXALIAS_RPL (fgets, char *, (char *s, int n, FILE *stream));
# else
_GL_CXXALIAS_SYS (fgets, char *, (char *s, int n, FILE *stream));
# endif
_GL_CXXALIASWARN (fgets);
#endif

#if @GNULIB_FOPEN@
# if @REPLACE_FOPEN@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fopen
#   define fopen rpl_fopen
#  endif
_GL_FUNCDECL_RPL (fopen, FILE *, (const char *filename, const char *mode)
                                 _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (fopen, FILE *, (const char *filename, const char *mode));
# else
_GL_CXXALIAS_SYS (fopen, FILE *, (const char *filename, const char *mode));
# endif
_GL_CXXALIASWARN (fopen);
#elif defined GNULIB_POSIXCHECK
# undef fopen
/* Assume fopen is always declared.  */
_GL_WARN_ON_USE (fopen, "fopen on Win32 platforms is not POSIX compatible - "
                 "use gnulib module fopen for portability");
#endif

#if @GNULIB_FPRINTF_POSIX@ || @GNULIB_FPRINTF@
# if (@GNULIB_FPRINTF_POSIX@ && @REPLACE_FPRINTF@) \
     || (@GNULIB_FPRINTF@ && @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@))
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define fprintf rpl_fprintf
#  endif
#  define GNULIB_overrides_fprintf 1
#  if @GNULIB_FPRINTF_POSIX@ || @GNULIB_VFPRINTF_POSIX@
_GL_FUNCDECL_RPL (fprintf, int, (FILE *fp, const char *format, ...)
                                _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                                _GL_ARG_NONNULL ((1, 2)));
#  else
_GL_FUNCDECL_RPL (fprintf, int, (FILE *fp, const char *format, ...)
                                _GL_ATTRIBUTE_FORMAT_PRINTF_SYSTEM (2, 3)
                                _GL_ARG_NONNULL ((1, 2)));
#  endif
_GL_CXXALIAS_RPL (fprintf, int, (FILE *fp, const char *format, ...));
# else
_GL_CXXALIAS_SYS (fprintf, int, (FILE *fp, const char *format, ...));
# endif
_GL_CXXALIASWARN (fprintf);
#endif
#if !@GNULIB_FPRINTF_POSIX@ && defined GNULIB_POSIXCHECK
# if !GNULIB_overrides_fprintf
#  undef fprintf
# endif
/* Assume fprintf is always declared.  */
_GL_WARN_ON_USE (fprintf, "fprintf is not always POSIX compliant - "
                 "use gnulib module fprintf-posix for portable "
                 "POSIX compliance");
#endif

#if @GNULIB_FPURGE@
/* Discard all pending buffered I/O data on STREAM.
   STREAM must not be wide-character oriented.
   When discarding pending output, the file position is set back to where it
   was before the write calls.  When discarding pending input, the file
   position is advanced to match the end of the previously read input.
   Return 0 if successful.  Upon error, return -1 and set errno.  */
# if @REPLACE_FPURGE@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define fpurge rpl_fpurge
#  endif
_GL_FUNCDECL_RPL (fpurge, int, (FILE *gl_stream) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (fpurge, int, (FILE *gl_stream));
# else
#  if !@HAVE_DECL_FPURGE@
_GL_FUNCDECL_SYS (fpurge, int, (FILE *gl_stream) _GL_ARG_NONNULL ((1)));
#  endif
_GL_CXXALIAS_SYS (fpurge, int, (FILE *gl_stream));
# endif
_GL_CXXALIASWARN (fpurge);
#elif defined GNULIB_POSIXCHECK
# undef fpurge
# if HAVE_RAW_DECL_FPURGE
_GL_WARN_ON_USE (fpurge, "fpurge is not always present - "
                 "use gnulib module fpurge for portability");
# endif
#endif

#if @GNULIB_FPUTC@
# if @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@)
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fputc
#   define fputc rpl_fputc
#  endif
_GL_FUNCDECL_RPL (fputc, int, (int c, FILE *stream) _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL (fputc, int, (int c, FILE *stream));
# else
_GL_CXXALIAS_SYS (fputc, int, (int c, FILE *stream));
# endif
_GL_CXXALIASWARN (fputc);
#endif

#if @GNULIB_FPUTS@
# if @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@)
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fputs
#   define fputs rpl_fputs
#  endif
_GL_FUNCDECL_RPL (fputs, int, (const char *string, FILE *stream)
                              _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (fputs, int, (const char *string, FILE *stream));
# else
_GL_CXXALIAS_SYS (fputs, int, (const char *string, FILE *stream));
# endif
_GL_CXXALIASWARN (fputs);
#endif

#if @GNULIB_FREAD@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fread
#   define fread rpl_fread
#  endif
_GL_FUNCDECL_RPL (fread, size_t, (void *ptr, size_t s, size_t n, FILE *stream)
                                 _GL_ARG_NONNULL ((4)));
_GL_CXXALIAS_RPL (fread, size_t, (void *ptr, size_t s, size_t n, FILE *stream));
# else
_GL_CXXALIAS_SYS (fread, size_t, (void *ptr, size_t s, size_t n, FILE *stream));
# endif
_GL_CXXALIASWARN (fread);
#endif

#if @GNULIB_FREOPEN@
# if @REPLACE_FREOPEN@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef freopen
#   define freopen rpl_freopen
#  endif
_GL_FUNCDECL_RPL (freopen, FILE *,
                  (const char *filename, const char *mode, FILE *stream)
                  _GL_ARG_NONNULL ((2, 3)));
_GL_CXXALIAS_RPL (freopen, FILE *,
                  (const char *filename, const char *mode, FILE *stream));
# else
_GL_CXXALIAS_SYS (freopen, FILE *,
                  (const char *filename, const char *mode, FILE *stream));
# endif
_GL_CXXALIASWARN (freopen);
#elif defined GNULIB_POSIXCHECK
# undef freopen
/* Assume freopen is always declared.  */
_GL_WARN_ON_USE (freopen,
                 "freopen on Win32 platforms is not POSIX compatible - "
                 "use gnulib module freopen for portability");
#endif

#if @GNULIB_FSCANF@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fscanf
#   define fscanf rpl_fscanf
#  endif
_GL_FUNCDECL_RPL (fscanf, int, (FILE *stream, const char *format, ...)
                               _GL_ATTRIBUTE_FORMAT_SCANF_SYSTEM (2, 3)
                               _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (fscanf, int, (FILE *stream, const char *format, ...));
# else
_GL_CXXALIAS_SYS (fscanf, int, (FILE *stream, const char *format, ...));
# endif
_GL_CXXALIASWARN (fscanf);
#endif


/* Set up the following warnings, based on which modules are in use.
   GNU Coding Standards discourage the use of fseek, since it imposes
   an arbitrary limitation on some 32-bit hosts.  Remember that the
   fseek module depends on the fseeko module, so we only have three
   cases to consider:

   1. The developer is not using either module.  Issue a warning under
   GNULIB_POSIXCHECK for both functions, to remind them that both
   functions have bugs on some systems.  _GL_NO_LARGE_FILES has no
   impact on this warning.

   2. The developer is using both modules.  They may be unaware of the
   arbitrary limitations of fseek, so issue a warning under
   GNULIB_POSIXCHECK.  On the other hand, they may be using both
   modules intentionally, so the developer can define
   _GL_NO_LARGE_FILES in the compilation units where the use of fseek
   is safe, to silence the warning.

   3. The developer is using the fseeko module, but not fseek.  Gnulib
   guarantees that fseek will still work around platform bugs in that
   case, but we presume that the developer is aware of the pitfalls of
   fseek and was trying to avoid it, so issue a warning even when
   GNULIB_POSIXCHECK is undefined.  Again, _GL_NO_LARGE_FILES can be
   defined to silence the warning in particular compilation units.
   In C++ compilations with GNULIB_NAMESPACE, in order to avoid that
   fseek gets defined as a macro, it is recommended that the developer
   uses the fseek module, even if he is not calling the fseek function.

   Most gnulib clients that perform stream operations should fall into
   category 3.  */

#if @GNULIB_FSEEK@
# if defined GNULIB_POSIXCHECK && !defined _GL_NO_LARGE_FILES
#  define _GL_FSEEK_WARN /* Category 2, above.  */
#  undef fseek
# endif
# if @REPLACE_FSEEK@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fseek
#   define fseek rpl_fseek
#  endif
_GL_FUNCDECL_RPL (fseek, int, (FILE *fp, long offset, int whence)
                              _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (fseek, int, (FILE *fp, long offset, int whence));
# else
_GL_CXXALIAS_SYS (fseek, int, (FILE *fp, long offset, int whence));
# endif
_GL_CXXALIASWARN (fseek);
#endif

#if @GNULIB_FSEEKO@
# if !@GNULIB_FSEEK@ && !defined _GL_NO_LARGE_FILES
#  define _GL_FSEEK_WARN /* Category 3, above.  */
#  undef fseek
# endif
# if @REPLACE_FSEEKO@
/* Provide an fseeko function that is aware of a preceding fflush(), and which
   detects pipes.  */
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fseeko
#   define fseeko rpl_fseeko
#  endif
_GL_FUNCDECL_RPL (fseeko, int, (FILE *fp, off_t offset, int whence)
                               _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (fseeko, int, (FILE *fp, off_t offset, int whence));
# else
#  if ! @HAVE_DECL_FSEEKO@
_GL_FUNCDECL_SYS (fseeko, int, (FILE *fp, off_t offset, int whence)
                               _GL_ARG_NONNULL ((1)));
#  endif
_GL_CXXALIAS_SYS (fseeko, int, (FILE *fp, off_t offset, int whence));
# endif
_GL_CXXALIASWARN (fseeko);
#elif defined GNULIB_POSIXCHECK
# define _GL_FSEEK_WARN /* Category 1, above.  */
# undef fseek
# undef fseeko
# if HAVE_RAW_DECL_FSEEKO
_GL_WARN_ON_USE (fseeko, "fseeko is unportable - "
                 "use gnulib module fseeko for portability");
# endif
#endif

#ifdef _GL_FSEEK_WARN
# undef _GL_FSEEK_WARN
/* Here, either fseek is undefined (but C89 guarantees that it is
   declared), or it is defined as rpl_fseek (declared above).  */
_GL_WARN_ON_USE (fseek, "fseek cannot handle files larger than 4 GB "
                 "on 32-bit platforms - "
                 "use fseeko function for handling of large files");
#endif


/* ftell, ftello.  See the comments on fseek/fseeko.  */

#if @GNULIB_FTELL@
# if defined GNULIB_POSIXCHECK && !defined _GL_NO_LARGE_FILES
#  define _GL_FTELL_WARN /* Category 2, above.  */
#  undef ftell
# endif
# if @REPLACE_FTELL@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef ftell
#   define ftell rpl_ftell
#  endif
_GL_FUNCDECL_RPL (ftell, long, (FILE *fp) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (ftell, long, (FILE *fp));
# else
_GL_CXXALIAS_SYS (ftell, long, (FILE *fp));
# endif
_GL_CXXALIASWARN (ftell);
#endif

#if @GNULIB_FTELLO@
# if !@GNULIB_FTELL@ && !defined _GL_NO_LARGE_FILES
#  define _GL_FTELL_WARN /* Category 3, above.  */
#  undef ftell
# endif
# if @REPLACE_FTELLO@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef ftello
#   define ftello rpl_ftello
#  endif
_GL_FUNCDECL_RPL (ftello, off_t, (FILE *fp) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (ftello, off_t, (FILE *fp));
# else
#  if ! @HAVE_DECL_FTELLO@
_GL_FUNCDECL_SYS (ftello, off_t, (FILE *fp) _GL_ARG_NONNULL ((1)));
#  endif
_GL_CXXALIAS_SYS (ftello, off_t, (FILE *fp));
# endif
_GL_CXXALIASWARN (ftello);
#elif defined GNULIB_POSIXCHECK
# define _GL_FTELL_WARN /* Category 1, above.  */
# undef ftell
# undef ftello
# if HAVE_RAW_DECL_FTELLO
_GL_WARN_ON_USE (ftello, "ftello is unportable - "
                 "use gnulib module ftello for portability");
# endif
#endif

#ifdef _GL_FTELL_WARN
# undef _GL_FTELL_WARN
/* Here, either ftell is undefined (but C89 guarantees that it is
   declared), or it is defined as rpl_ftell (declared above).  */
_GL_WARN_ON_USE (ftell, "ftell cannot handle files larger than 4 GB "
                 "on 32-bit platforms - "
                 "use ftello function for handling of large files");
#endif


#if @GNULIB_FWRITE@
# if @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@)
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef fwrite
#   define fwrite rpl_fwrite
#  endif
_GL_FUNCDECL_RPL (fwrite, size_t,
                  (const void *ptr, size_t s, size_t n, FILE *stream)
                  _GL_ARG_NONNULL ((1, 4)));
_GL_CXXALIAS_RPL (fwrite, size_t,
                  (const void *ptr, size_t s, size_t n, FILE *stream));
# else
_GL_CXXALIAS_SYS (fwrite, size_t,
                  (const void *ptr, size_t s, size_t n, FILE *stream));

/* Work around glibc bug 11959
   <http://sources.redhat.com/bugzilla/show_bug.cgi?id=11959>,
   which sometimes causes an unwanted diagnostic for fwrite calls.
   This affects only function declaration attributes, so it's not
   needed for C++.  */
#  if !defined __cplusplus && 0 < __USE_FORTIFY_LEVEL
static inline size_t _GL_ARG_NONNULL ((1, 4))
rpl_fwrite (const void *ptr, size_t s, size_t n, FILE *stream)
{
  size_t r = fwrite (ptr, s, n, stream);
  (void) r;
  return r;
}
#   undef fwrite
#   define fwrite rpl_fwrite
#  endif
# endif
_GL_CXXALIASWARN (fwrite);
#endif

#if @GNULIB_GETC@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef getc
#   define getc rpl_fgetc
#  endif
_GL_FUNCDECL_RPL (fgetc, int, (FILE *stream) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL_1 (getc, rpl_fgetc, int, (FILE *stream));
# else
_GL_CXXALIAS_SYS (getc, int, (FILE *stream));
# endif
_GL_CXXALIASWARN (getc);
#endif

#if @GNULIB_GETCHAR@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef getchar
#   define getchar rpl_getchar
#  endif
_GL_FUNCDECL_RPL (getchar, int, (void));
_GL_CXXALIAS_RPL (getchar, int, (void));
# else
_GL_CXXALIAS_SYS (getchar, int, (void));
# endif
_GL_CXXALIASWARN (getchar);
#endif

#if @GNULIB_GETDELIM@
/* Read input, up to (and including) the next occurrence of DELIMITER, from
   STREAM, store it in *LINEPTR (and NUL-terminate it).
   *LINEPTR is a pointer returned from malloc (or NULL), pointing to *LINESIZE
   bytes of space.  It is realloc'd as necessary.
   Return the number of bytes read and stored at *LINEPTR (not including the
   NUL terminator), or -1 on error or EOF.  */
# if @REPLACE_GETDELIM@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef getdelim
#   define getdelim rpl_getdelim
#  endif
_GL_FUNCDECL_RPL (getdelim, ssize_t,
                  (char **lineptr, size_t *linesize, int delimiter,
                   FILE *stream)
                  _GL_ARG_NONNULL ((1, 2, 4)));
_GL_CXXALIAS_RPL (getdelim, ssize_t,
                  (char **lineptr, size_t *linesize, int delimiter,
                   FILE *stream));
# else
#  if !@HAVE_DECL_GETDELIM@
_GL_FUNCDECL_SYS (getdelim, ssize_t,
                  (char **lineptr, size_t *linesize, int delimiter,
                   FILE *stream)
                  _GL_ARG_NONNULL ((1, 2, 4)));
#  endif
_GL_CXXALIAS_SYS (getdelim, ssize_t,
                  (char **lineptr, size_t *linesize, int delimiter,
                   FILE *stream));
# endif
_GL_CXXALIASWARN (getdelim);
#elif defined GNULIB_POSIXCHECK
# undef getdelim
# if HAVE_RAW_DECL_GETDELIM
_GL_WARN_ON_USE (getdelim, "getdelim is unportable - "
                 "use gnulib module getdelim for portability");
# endif
#endif

#if @GNULIB_GETLINE@
/* Read a line, up to (and including) the next newline, from STREAM, store it
   in *LINEPTR (and NUL-terminate it).
   *LINEPTR is a pointer returned from malloc (or NULL), pointing to *LINESIZE
   bytes of space.  It is realloc'd as necessary.
   Return the number of bytes read and stored at *LINEPTR (not including the
   NUL terminator), or -1 on error or EOF.  */
# if @REPLACE_GETLINE@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef getline
#   define getline rpl_getline
#  endif
_GL_FUNCDECL_RPL (getline, ssize_t,
                  (char **lineptr, size_t *linesize, FILE *stream)
                  _GL_ARG_NONNULL ((1, 2, 3)));
_GL_CXXALIAS_RPL (getline, ssize_t,
                  (char **lineptr, size_t *linesize, FILE *stream));
# else
#  if !@HAVE_DECL_GETLINE@
_GL_FUNCDECL_SYS (getline, ssize_t,
                  (char **lineptr, size_t *linesize, FILE *stream)
                  _GL_ARG_NONNULL ((1, 2, 3)));
#  endif
_GL_CXXALIAS_SYS (getline, ssize_t,
                  (char **lineptr, size_t *linesize, FILE *stream));
# endif
# if @HAVE_DECL_GETLINE@
_GL_CXXALIASWARN (getline);
# endif
#elif defined GNULIB_POSIXCHECK
# undef getline
# if HAVE_RAW_DECL_GETLINE
_GL_WARN_ON_USE (getline, "getline is unportable - "
                 "use gnulib module getline for portability");
# endif
#endif

#if @GNULIB_GETS@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef gets
#   define gets rpl_gets
#  endif
_GL_FUNCDECL_RPL (gets, char *, (char *s) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (gets, char *, (char *s));
# else
_GL_CXXALIAS_SYS (gets, char *, (char *s));
#  undef gets
# endif
_GL_CXXALIASWARN (gets);
/* It is very rare that the developer ever has full control of stdin,
   so any use of gets warrants an unconditional warning.  Assume it is
   always declared, since it is required by C89.  */
#if defined(__GLIBC__) && !defined(__UCLIBC__) && !__GLIBC_PREREQ(2, 16)
 _GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
#endif
#endif


#if @GNULIB_OBSTACK_PRINTF@ || @GNULIB_OBSTACK_PRINTF_POSIX@
struct obstack;
/* Grow an obstack with formatted output.  Return the number of
   bytes added to OBS.  No trailing nul byte is added, and the
   object should be closed with obstack_finish before use.  Upon
   memory allocation error, call obstack_alloc_failed_handler.  Upon
   other error, return -1.  */
# if @REPLACE_OBSTACK_PRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define obstack_printf rpl_obstack_printf
#  endif
_GL_FUNCDECL_RPL (obstack_printf, int,
                  (struct obstack *obs, const char *format, ...)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                  _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (obstack_printf, int,
                  (struct obstack *obs, const char *format, ...));
# else
#  if !@HAVE_DECL_OBSTACK_PRINTF@
_GL_FUNCDECL_SYS (obstack_printf, int,
                  (struct obstack *obs, const char *format, ...)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                  _GL_ARG_NONNULL ((1, 2)));
#  endif
_GL_CXXALIAS_SYS (obstack_printf, int,
                  (struct obstack *obs, const char *format, ...));
# endif
_GL_CXXALIASWARN (obstack_printf);
# if @REPLACE_OBSTACK_PRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define obstack_vprintf rpl_obstack_vprintf
#  endif
_GL_FUNCDECL_RPL (obstack_vprintf, int,
                  (struct obstack *obs, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                  _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (obstack_vprintf, int,
                  (struct obstack *obs, const char *format, va_list args));
# else
#  if !@HAVE_DECL_OBSTACK_PRINTF@
_GL_FUNCDECL_SYS (obstack_vprintf, int,
                  (struct obstack *obs, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                  _GL_ARG_NONNULL ((1, 2)));
#  endif
_GL_CXXALIAS_SYS (obstack_vprintf, int,
                  (struct obstack *obs, const char *format, va_list args));
# endif
_GL_CXXALIASWARN (obstack_vprintf);
#endif

#if @GNULIB_PERROR@
/* Print a message to standard error, describing the value of ERRNO,
   (if STRING is not NULL and not empty) prefixed with STRING and ": ",
   and terminated with a newline.  */
# if @REPLACE_PERROR@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define perror rpl_perror
#  endif
_GL_FUNCDECL_RPL (perror, void, (const char *string));
_GL_CXXALIAS_RPL (perror, void, (const char *string));
# else
_GL_CXXALIAS_SYS (perror, void, (const char *string));
# endif
_GL_CXXALIASWARN (perror);
#elif defined GNULIB_POSIXCHECK
# undef perror
/* Assume perror is always declared.  */
_GL_WARN_ON_USE (perror, "perror is not always POSIX compliant - "
                 "use gnulib module perror for portability");
#endif

#if @GNULIB_POPEN@
# if @REPLACE_POPEN@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef popen
#   define popen rpl_popen
#  endif
_GL_FUNCDECL_RPL (popen, FILE *, (const char *cmd, const char *mode)
                                 _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (popen, FILE *, (const char *cmd, const char *mode));
# else
_GL_CXXALIAS_SYS (popen, FILE *, (const char *cmd, const char *mode));
# endif
_GL_CXXALIASWARN (popen);
#elif defined GNULIB_POSIXCHECK
# undef popen
# if HAVE_RAW_DECL_POPEN
_GL_WARN_ON_USE (popen, "popen is buggy on some platforms - "
                 "use gnulib module popen or pipe for more portability");
# endif
#endif

#if @GNULIB_PRINTF_POSIX@ || @GNULIB_PRINTF@
# if (@GNULIB_PRINTF_POSIX@ && @REPLACE_PRINTF@) \
     || (@GNULIB_PRINTF@ && @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@))
#  if defined __GNUC__
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
/* Don't break __attribute__((format(printf,M,N))).  */
#    define printf __printf__
#   endif
#   if @GNULIB_PRINTF_POSIX@ || @GNULIB_VFPRINTF_POSIX@
_GL_FUNCDECL_RPL_1 (__printf__, int,
                    (const char *format, ...)
                    __asm__ (@ASM_SYMBOL_PREFIX@
                             _GL_STDIO_MACROEXPAND_AND_STRINGIZE(rpl_printf))
                    _GL_ATTRIBUTE_FORMAT_PRINTF (1, 2)
                    _GL_ARG_NONNULL ((1)));
#   else
_GL_FUNCDECL_RPL_1 (__printf__, int,
                    (const char *format, ...)
                    __asm__ (@ASM_SYMBOL_PREFIX@
                             _GL_STDIO_MACROEXPAND_AND_STRINGIZE(rpl_printf))
                    _GL_ATTRIBUTE_FORMAT_PRINTF_SYSTEM (1, 2)
                    _GL_ARG_NONNULL ((1)));
#   endif
_GL_CXXALIAS_RPL_1 (printf, __printf__, int, (const char *format, ...));
#  else
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    define printf rpl_printf
#   endif
_GL_FUNCDECL_RPL (printf, int,
                  (const char *format, ...)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (1, 2)
                  _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (printf, int, (const char *format, ...));
#  endif
#  define GNULIB_overrides_printf 1
# else
_GL_CXXALIAS_SYS (printf, int, (const char *format, ...));
# endif
_GL_CXXALIASWARN (printf);
#endif
#if !@GNULIB_PRINTF_POSIX@ && defined GNULIB_POSIXCHECK
# if !GNULIB_overrides_printf
#  undef printf
# endif
/* Assume printf is always declared.  */
_GL_WARN_ON_USE (printf, "printf is not always POSIX compliant - "
                 "use gnulib module printf-posix for portable "
                 "POSIX compliance");
#endif

#if @GNULIB_PUTC@
# if @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@)
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef putc
#   define putc rpl_fputc
#  endif
_GL_FUNCDECL_RPL (fputc, int, (int c, FILE *stream) _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL_1 (putc, rpl_fputc, int, (int c, FILE *stream));
# else
_GL_CXXALIAS_SYS (putc, int, (int c, FILE *stream));
# endif
_GL_CXXALIASWARN (putc);
#endif

#if @GNULIB_PUTCHAR@
# if @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@)
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef putchar
#   define putchar rpl_putchar
#  endif
_GL_FUNCDECL_RPL (putchar, int, (int c));
_GL_CXXALIAS_RPL (putchar, int, (int c));
# else
_GL_CXXALIAS_SYS (putchar, int, (int c));
# endif
_GL_CXXALIASWARN (putchar);
#endif

#if @GNULIB_PUTS@
# if @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@)
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef puts
#   define puts rpl_puts
#  endif
_GL_FUNCDECL_RPL (puts, int, (const char *string) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (puts, int, (const char *string));
# else
_GL_CXXALIAS_SYS (puts, int, (const char *string));
# endif
_GL_CXXALIASWARN (puts);
#endif

#if @GNULIB_REMOVE@
# if @REPLACE_REMOVE@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef remove
#   define remove rpl_remove
#  endif
_GL_FUNCDECL_RPL (remove, int, (const char *name) _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (remove, int, (const char *name));
# else
_GL_CXXALIAS_SYS (remove, int, (const char *name));
# endif
_GL_CXXALIASWARN (remove);
#elif defined GNULIB_POSIXCHECK
# undef remove
/* Assume remove is always declared.  */
_GL_WARN_ON_USE (remove, "remove cannot handle directories on some platforms - "
                 "use gnulib module remove for more portability");
#endif

#if @GNULIB_RENAME@
# if @REPLACE_RENAME@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef rename
#   define rename rpl_rename
#  endif
_GL_FUNCDECL_RPL (rename, int,
                  (const char *old_filename, const char *new_filename)
                  _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (rename, int,
                  (const char *old_filename, const char *new_filename));
# else
_GL_CXXALIAS_SYS (rename, int,
                  (const char *old_filename, const char *new_filename));
# endif
_GL_CXXALIASWARN (rename);
#elif defined GNULIB_POSIXCHECK
# undef rename
/* Assume rename is always declared.  */
_GL_WARN_ON_USE (rename, "rename is buggy on some platforms - "
                 "use gnulib module rename for more portability");
#endif

#if @GNULIB_RENAMEAT@
# if @REPLACE_RENAMEAT@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef renameat
#   define renameat rpl_renameat
#  endif
_GL_FUNCDECL_RPL (renameat, int,
                  (int fd1, char const *file1, int fd2, char const *file2)
                  _GL_ARG_NONNULL ((2, 4)));
_GL_CXXALIAS_RPL (renameat, int,
                  (int fd1, char const *file1, int fd2, char const *file2));
# else
#  if !@HAVE_RENAMEAT@
_GL_FUNCDECL_SYS (renameat, int,
                  (int fd1, char const *file1, int fd2, char const *file2)
                  _GL_ARG_NONNULL ((2, 4)));
#  endif
_GL_CXXALIAS_SYS (renameat, int,
                  (int fd1, char const *file1, int fd2, char const *file2));
# endif
_GL_CXXALIASWARN (renameat);
#elif defined GNULIB_POSIXCHECK
# undef renameat
# if HAVE_RAW_DECL_RENAMEAT
_GL_WARN_ON_USE (renameat, "renameat is not portable - "
                 "use gnulib module renameat for portability");
# endif
#endif

#if @GNULIB_SCANF@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if defined __GNUC__
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef scanf
/* Don't break __attribute__((format(scanf,M,N))).  */
#    define scanf __scanf__
#   endif
_GL_FUNCDECL_RPL_1 (__scanf__, int,
                    (const char *format, ...)
                    __asm__ (@ASM_SYMBOL_PREFIX@
                             _GL_STDIO_MACROEXPAND_AND_STRINGIZE(rpl_scanf))
                    _GL_ATTRIBUTE_FORMAT_SCANF_SYSTEM (1, 2)
                    _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL_1 (scanf, __scanf__, int, (const char *format, ...));
#  else
#   if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#    undef scanf
#    define scanf rpl_scanf
#   endif
_GL_FUNCDECL_RPL (scanf, int, (const char *format, ...)
                              _GL_ATTRIBUTE_FORMAT_SCANF_SYSTEM (1, 2)
                              _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (scanf, int, (const char *format, ...));
#  endif
# else
_GL_CXXALIAS_SYS (scanf, int, (const char *format, ...));
# endif
_GL_CXXALIASWARN (scanf);
#endif

#if @GNULIB_SNPRINTF@
# if @REPLACE_SNPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define snprintf rpl_snprintf
#  endif
_GL_FUNCDECL_RPL (snprintf, int,
                  (char *str, size_t size, const char *format, ...)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (3, 4)
                  _GL_ARG_NONNULL ((3)));
_GL_CXXALIAS_RPL (snprintf, int,
                  (char *str, size_t size, const char *format, ...));
# else
#  if !@HAVE_DECL_SNPRINTF@
_GL_FUNCDECL_SYS (snprintf, int,
                  (char *str, size_t size, const char *format, ...)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (3, 4)
                  _GL_ARG_NONNULL ((3)));
#  endif
_GL_CXXALIAS_SYS (snprintf, int,
                  (char *str, size_t size, const char *format, ...));
# endif
_GL_CXXALIASWARN (snprintf);
#elif defined GNULIB_POSIXCHECK
# undef snprintf
# if HAVE_RAW_DECL_SNPRINTF
_GL_WARN_ON_USE (snprintf, "snprintf is unportable - "
                 "use gnulib module snprintf for portability");
# endif
#endif

/* Some people would argue that sprintf should be handled like gets
   (for example, OpenBSD issues a link warning for both functions),
   since both can cause security holes due to buffer overruns.
   However, we believe that sprintf can be used safely, and is more
   efficient than snprintf in those safe cases; and as proof of our
   belief, we use sprintf in several gnulib modules.  So this header
   intentionally avoids adding a warning to sprintf except when
   GNULIB_POSIXCHECK is defined.  */

#if @GNULIB_SPRINTF_POSIX@
# if @REPLACE_SPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define sprintf rpl_sprintf
#  endif
_GL_FUNCDECL_RPL (sprintf, int, (char *str, const char *format, ...)
                                _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                                _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (sprintf, int, (char *str, const char *format, ...));
# else
_GL_CXXALIAS_SYS (sprintf, int, (char *str, const char *format, ...));
# endif
_GL_CXXALIASWARN (sprintf);
#elif defined GNULIB_POSIXCHECK
# undef sprintf
/* Assume sprintf is always declared.  */
_GL_WARN_ON_USE (sprintf, "sprintf is not always POSIX compliant - "
                 "use gnulib module sprintf-posix for portable "
                 "POSIX compliance");
#endif

#if @GNULIB_TMPFILE@
# if @REPLACE_TMPFILE@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define tmpfile rpl_tmpfile
#  endif
_GL_FUNCDECL_RPL (tmpfile, FILE *, (void));
_GL_CXXALIAS_RPL (tmpfile, FILE *, (void));
# else
_GL_CXXALIAS_SYS (tmpfile, FILE *, (void));
# endif
_GL_CXXALIASWARN (tmpfile);
#elif defined GNULIB_POSIXCHECK
# undef tmpfile
# if HAVE_RAW_DECL_TMPFILE
_GL_WARN_ON_USE (tmpfile, "tmpfile is not usable on mingw - "
                 "use gnulib module tmpfile for portability");
# endif
#endif

#if @GNULIB_VASPRINTF@
/* Write formatted output to a string dynamically allocated with malloc().
   If the memory allocation succeeds, store the address of the string in
   *RESULT and return the number of resulting bytes, excluding the trailing
   NUL.  Upon memory allocation error, or some other error, return -1.  */
# if @REPLACE_VASPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define asprintf rpl_asprintf
#  endif
_GL_FUNCDECL_RPL (asprintf, int,
                  (char **result, const char *format, ...)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                  _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (asprintf, int,
                  (char **result, const char *format, ...));
# else
#  if !@HAVE_VASPRINTF@
_GL_FUNCDECL_SYS (asprintf, int,
                  (char **result, const char *format, ...)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 3)
                  _GL_ARG_NONNULL ((1, 2)));
#  endif
_GL_CXXALIAS_SYS (asprintf, int,
                  (char **result, const char *format, ...));
# endif
_GL_CXXALIASWARN (asprintf);
# if @REPLACE_VASPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define vasprintf rpl_vasprintf
#  endif
_GL_FUNCDECL_RPL (vasprintf, int,
                  (char **result, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                  _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (vasprintf, int,
                  (char **result, const char *format, va_list args));
# else
#  if !@HAVE_VASPRINTF@
_GL_FUNCDECL_SYS (vasprintf, int,
                  (char **result, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                  _GL_ARG_NONNULL ((1, 2)));
#  endif
_GL_CXXALIAS_SYS (vasprintf, int,
                  (char **result, const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vasprintf);
#endif

#if @GNULIB_VDPRINTF@
# if @REPLACE_VDPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define vdprintf rpl_vdprintf
#  endif
_GL_FUNCDECL_RPL (vdprintf, int, (int fd, const char *format, va_list args)
                                 _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                                 _GL_ARG_NONNULL ((2)));
_GL_CXXALIAS_RPL (vdprintf, int, (int fd, const char *format, va_list args));
# else
#  if !@HAVE_VDPRINTF@
_GL_FUNCDECL_SYS (vdprintf, int, (int fd, const char *format, va_list args)
                                 _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                                 _GL_ARG_NONNULL ((2)));
#  endif
/* Need to cast, because on Solaris, the third parameter will likely be
                                                    __va_list args.  */
_GL_CXXALIAS_SYS_CAST (vdprintf, int,
                       (int fd, const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vdprintf);
#elif defined GNULIB_POSIXCHECK
# undef vdprintf
# if HAVE_RAW_DECL_VDPRINTF
_GL_WARN_ON_USE (vdprintf, "vdprintf is unportable - "
                 "use gnulib module vdprintf for portability");
# endif
#endif

#if @GNULIB_VFPRINTF_POSIX@ || @GNULIB_VFPRINTF@
# if (@GNULIB_VFPRINTF_POSIX@ && @REPLACE_VFPRINTF@) \
     || (@GNULIB_VFPRINTF@ && @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@))
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define vfprintf rpl_vfprintf
#  endif
#  define GNULIB_overrides_vfprintf 1
#  if @GNULIB_VFPRINTF_POSIX@
_GL_FUNCDECL_RPL (vfprintf, int, (FILE *fp, const char *format, va_list args)
                                 _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                                 _GL_ARG_NONNULL ((1, 2)));
#  else
_GL_FUNCDECL_RPL (vfprintf, int, (FILE *fp, const char *format, va_list args)
                                 _GL_ATTRIBUTE_FORMAT_PRINTF_SYSTEM (2, 0)
                                 _GL_ARG_NONNULL ((1, 2)));
#  endif
_GL_CXXALIAS_RPL (vfprintf, int, (FILE *fp, const char *format, va_list args));
# else
/* Need to cast, because on Solaris, the third parameter is
                                                      __va_list args
   and GCC's fixincludes did not change this to __gnuc_va_list.  */
_GL_CXXALIAS_SYS_CAST (vfprintf, int,
                       (FILE *fp, const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vfprintf);
#endif
#if !@GNULIB_VFPRINTF_POSIX@ && defined GNULIB_POSIXCHECK
# if !GNULIB_overrides_vfprintf
#  undef vfprintf
# endif
/* Assume vfprintf is always declared.  */
_GL_WARN_ON_USE (vfprintf, "vfprintf is not always POSIX compliant - "
                 "use gnulib module vfprintf-posix for portable "
                      "POSIX compliance");
#endif

#if @GNULIB_VFSCANF@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef vfscanf
#   define vfscanf rpl_vfscanf
#  endif
_GL_FUNCDECL_RPL (vfscanf, int,
                  (FILE *stream, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_SCANF_SYSTEM (2, 0)
                  _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (vfscanf, int,
                  (FILE *stream, const char *format, va_list args));
# else
_GL_CXXALIAS_SYS (vfscanf, int,
                  (FILE *stream, const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vfscanf);
#endif

#if @GNULIB_VPRINTF_POSIX@ || @GNULIB_VPRINTF@
# if (@GNULIB_VPRINTF_POSIX@ && @REPLACE_VPRINTF@) \
     || (@GNULIB_VPRINTF@ && @REPLACE_STDIO_WRITE_FUNCS@ && (@GNULIB_STDIO_H_NONBLOCKING@ || @GNULIB_STDIO_H_SIGPIPE@))
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define vprintf rpl_vprintf
#  endif
#  define GNULIB_overrides_vprintf 1
#  if @GNULIB_VPRINTF_POSIX@ || @GNULIB_VFPRINTF_POSIX@
_GL_FUNCDECL_RPL (vprintf, int, (const char *format, va_list args)
                                _GL_ATTRIBUTE_FORMAT_PRINTF (1, 0)
                                _GL_ARG_NONNULL ((1)));
#  else
_GL_FUNCDECL_RPL (vprintf, int, (const char *format, va_list args)
                                _GL_ATTRIBUTE_FORMAT_PRINTF_SYSTEM (1, 0)
                                _GL_ARG_NONNULL ((1)));
#  endif
_GL_CXXALIAS_RPL (vprintf, int, (const char *format, va_list args));
# else
/* Need to cast, because on Solaris, the second parameter is
                                                          __va_list args
   and GCC's fixincludes did not change this to __gnuc_va_list.  */
_GL_CXXALIAS_SYS_CAST (vprintf, int, (const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vprintf);
#endif
#if !@GNULIB_VPRINTF_POSIX@ && defined GNULIB_POSIXCHECK
# if !GNULIB_overrides_vprintf
#  undef vprintf
# endif
/* Assume vprintf is always declared.  */
_GL_WARN_ON_USE (vprintf, "vprintf is not always POSIX compliant - "
                 "use gnulib module vprintf-posix for portable "
                 "POSIX compliance");
#endif

#if @GNULIB_VSCANF@
# if @REPLACE_STDIO_READ_FUNCS@ && @GNULIB_STDIO_H_NONBLOCKING@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   undef vscanf
#   define vscanf rpl_vscanf
#  endif
_GL_FUNCDECL_RPL (vscanf, int, (const char *format, va_list args)
                               _GL_ATTRIBUTE_FORMAT_SCANF_SYSTEM (1, 0)
                               _GL_ARG_NONNULL ((1)));
_GL_CXXALIAS_RPL (vscanf, int, (const char *format, va_list args));
# else
_GL_CXXALIAS_SYS (vscanf, int, (const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vscanf);
#endif

#if @GNULIB_VSNPRINTF@
# if @REPLACE_VSNPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define vsnprintf rpl_vsnprintf
#  endif
_GL_FUNCDECL_RPL (vsnprintf, int,
                  (char *str, size_t size, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (3, 0)
                  _GL_ARG_NONNULL ((3)));
_GL_CXXALIAS_RPL (vsnprintf, int,
                  (char *str, size_t size, const char *format, va_list args));
# else
#  if !@HAVE_DECL_VSNPRINTF@
_GL_FUNCDECL_SYS (vsnprintf, int,
                  (char *str, size_t size, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (3, 0)
                  _GL_ARG_NONNULL ((3)));
#  endif
_GL_CXXALIAS_SYS (vsnprintf, int,
                  (char *str, size_t size, const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vsnprintf);
#elif defined GNULIB_POSIXCHECK
# undef vsnprintf
# if HAVE_RAW_DECL_VSNPRINTF
_GL_WARN_ON_USE (vsnprintf, "vsnprintf is unportable - "
                 "use gnulib module vsnprintf for portability");
# endif
#endif

#if @GNULIB_VSPRINTF_POSIX@
# if @REPLACE_VSPRINTF@
#  if !(defined __cplusplus && defined GNULIB_NAMESPACE)
#   define vsprintf rpl_vsprintf
#  endif
_GL_FUNCDECL_RPL (vsprintf, int,
                  (char *str, const char *format, va_list args)
                  _GL_ATTRIBUTE_FORMAT_PRINTF (2, 0)
                  _GL_ARG_NONNULL ((1, 2)));
_GL_CXXALIAS_RPL (vsprintf, int,
                  (char *str, const char *format, va_list args));
# else
/* Need to cast, because on Solaris, the third parameter is
                                                       __va_list args
   and GCC's fixincludes did not change this to __gnuc_va_list.  */
_GL_CXXALIAS_SYS_CAST (vsprintf, int,
                       (char *str, const char *format, va_list args));
# endif
_GL_CXXALIASWARN (vsprintf);
#elif defined GNULIB_POSIXCHECK
# undef vsprintf
/* Assume vsprintf is always declared.  */
_GL_WARN_ON_USE (vsprintf, "vsprintf is not always POSIX compliant - "
                 "use gnulib module vsprintf-posix for portable "
                      "POSIX compliance");
#endif


#endif /* _@GUARD_PREFIX@_STDIO_H */
#endif /* _@GUARD_PREFIX@_STDIO_H */
#endif

EOF
make && make install
fi
echo "/usr/local/phpextend/lib" > /etc/ld.so.conf.d/phpextend.conf
ldconfig
cd $DOCUMENT_ROOT/../sources/php-5.5.16
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--enable-fastcgi \
--with-php=/usr/local/php \
--with-phpi=/usr/local/php/bin/php_config \
--disable-debug --disable-ipv6 \
--with-iconv-dir=/usr/local/phpextend \
--with-freetype-dir=/usr/local/phpextend \
--with-jpeg-dir=/usr/local/phpextend \
--with-png-dir=/usr/local/phpextend \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-fpm \
--enable-mbstring  \
--with-gd \
--enable-gd-native-ttf \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--enable-cli \
--with-mcrypt=/usr/local/phpextend \
--with-mysql=/usr/local/mysql \
--with-mysqli=/usr/local/mysql/bin/mysql_config \
--with-pdo-mysql=/usr/local/mysql
grep "^EXTRA_LIBS =" Makefile | grep -q "-liconv" || sed -i 's/EXTRA_LIBS =/EXTRA_LIBS = -liconv /g' Makefile
make && make install

}
config_php()
{
cd /usr/local/php/etc
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
if
grep -qE "^listen.owner[ ]*=[ ]*www" /usr/local/php/etc/php-fpm.conf
then
sed -i '/^listen.owner/d' /usr/local/php/etc/php-fpm.conf
echo "listen.owner = www" >> /usr/local/php/etc/php-fpm.conf
fi
if
grep -qE "^listen.group[ ]*=[ ]*www" /usr/local/php/etc/php-fpm.conf
then
sed -i '/^listen.group/d' /usr/local/php/etc/php-fpm.conf
echo "listen.group = www" >> /usr/local/php/etc/php-fpm.conf
fi
if
grep -qE "^listen.mode[ ]*=[ ]*0660" /usr/local/php/etc/php-fpm.conf
then
sed -i '/^listen.mode/d' /usr/local/php/etc/php-fpm.conf
echo "listen.mode = 0660" >> /usr/local/php/etc/php-fpm.conf
fi
sed -i '/^user.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i '/^group.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\user = www" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\group = www" /usr/local/php/etc/php-fpm.conf

cd $DOCUMENT_ROOT/../sources/php-5.5.16
cp php.ini-development /usr/local/php/etc/php.ini
cp sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
useradd www
service php-fpm start
echo "$OS" | grep -iq "centos" && chkconfig --add php-fpm && chkconfig php-fpm on
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f php-fpm defaults #remove
echo "$OS" | grep -iq "debian" && update-rc.d -f php-fpm defaults
}

do_install_php()
{
[ ! -x /usr/local/mysql/bin/mysqld ] && echo "Please Install Mysql First."  && exit 1
check_php_installed && echo "php binary installed" && exit 1
touch $DOCUMENT_ROOT/../tmp/php_ins_detail.log
main.sbin pregress_schedule option="add" task="_PS_Install_php" schedule="{\"_PS_1_Download_Sources\":\"0\",\"_PS_2_Make_install_PHP_Dependence\":\"0\",\"_PS_3_Make_install_PHP\":\"0\",\"_PS_4_Config_PHP\":\"0\",\"_PS_5_PHP_finished_Installtion\":\"0\"}" detail_file="$DOCUMENT_ROOT/../tmp/php_ins_detail.log" app="php" status="working"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="10"
main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_1_Download_Sources"

main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="30"
download_php > $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_php" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_2_Make_install_PHP_Dependence"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="45"
install_php_dependence > $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1

main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_3_Make_install_PHP"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="60"
make_php >> $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1
if
[ $? -ne 0 ]
then
main.sbin pregress_schedule option="change_status" task="_PS_Install_php" status_now="fail"
exit 1
fi

main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_4_Config_PHP"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="80"
config_php >> $DOCUMENT_ROOT/../tmp/php_ins_detail.log 2>&1
main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_5_PHP_finished_Installtion"
main.sbin pregress_schedule option="now" task="_PS_Install_php" schedule_now="_PS_5_PHP_finished_Installtion"
main.sbin pregress_schedule option="change_pregress" task="_PS_Install_php" pregress_now="100"
main.sbin pregress_schedule option="change_status" task="_PS_Install_php" status_now="success"

}

check_php_installed()
{
if
[ -x /usr/local/php/bin/php ]
then
return 0
else
return 1
fi
}
install_php()
{
[ ! -x /usr/local/mysql/bin/mysqld ] && echo "Please Install Mysql First."  && exit 1
check_php_installed ||[ "$(main.sbin pregress_schedule option="get_status" task="_PS_Install_php" | grep -Po '[\w]*')" = "working" ] || rm -f $DOCUMENT_ROOT/../tmp/php_ins_detail.log
[ -f $DOCUMENT_ROOT/../tmp/php_ins_detail.log ] || do_install_php &
. $DOCUMENT_ROOT/apps/notice/notice_lib.sh
FORM_ps="_PS_Install_php"
get_pregress_schedule_notice_detail
}
pre_php_install_config()
{
# echo "$FORM_datadir" | grep -q "^/" || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
# echo "$FORM_datadir" | main.sbin regx_str ispath || (echo "datadir Not path" | main.sbin output_json 1) || exit 1
# echo "`dirname $FORM_log_error`" | grep -q "^/" || (echo "log_error Error" | main.sbin output_json 1) || exit 1
# echo "`dirname $FORM_log_error`" | main.sbin regx_str ispath || (echo "log_error Error" | main.sbin output_json 1) || exit 1
# echo "$FORM_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
# echo "datadir=$FORM_datadir" > $DOCUMENT_ROOT/../tmp/php.config.tmp
# echo "port=$FORM_port" >> $DOCUMENT_ROOT/../tmp/php.config.tmp
# echo "log_error=$FORM_log_error" >> $DOCUMENT_ROOT/../tmp/php.config.tmp
(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}
pre_install_php()
{
[ ! -x /usr/local/mysql/bin/mysqld ] && echo "Please Install Mysql First."  && exit 1
echo "$_LANG_Ready_to_Install"



}
base_setting_fpm()
{
echo "$FORM_fpm_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
[ "$FORM_fpm_bind_address" = "0.0.0.0" ] || ifconfig | grep -q "$FORM_bind_address" || (echo "Bind-address Error" | main.sbin output_json 1) || exit 1

sed -i '/^listen.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen = $FORM_fpm_bind_address:$FORM_fpm_port" /usr/local/php/etc/php-fpm.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_modified_to_tcp" \
				detail="_NOTICE_php_modified_to_tcp_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"fpm_bind_address\":\"$FORM_fpm_bind_address\", \
						\"fpm_port\":\"$FORM_fpm_port\" \
					}" >/dev/null 2>&1

(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}
base_setting_socket()
{
# echo "$FORM_port" | main.sbin regx_str islang_alb || (echo "port Error" | main.sbin output_json 1) || exit 1
# [ "$FORM_bind_address" = "0.0.0.0" ] || ifconfig | grep -q "$FORM_bind_address" || (echo "Bind-address Error" | main.sbin output_json 1) || exit 1

[ -d $(dirname $FORM_socket_bind_address) ] || (echo "目录错误" | main.sbin output_json 1) || exit 1
grep -q "^$FORM_socket_listen_owner" /etc/passwd || (echo "用户不存在" | main.sbin output_json 1) || exit 1
grep -q "^$FORM_socket_listen_group" /etc/group || (echo "用户组不存在" | main.sbin output_json 1) || exit 1
echo "$FORM_socket_listen_mode" | main.sbin regx_str islang_alb || (echo "用户组不存在" | main.sbin output_json 1) || exit 1

sed -i '/^listen.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen = $FORM_socket_bind_address" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen.owner = $FORM_socket_listen_owner" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen.group = $FORM_socket_listen_group" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\listen.mode = $FORM_socket_listen_mode" /usr/local/php/etc/php-fpm.conf
sed -i '/^user.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i '/^group.*=/d' /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\user = $FORM_socket_listen_owner" /usr/local/php/etc/php-fpm.conf
sed -i "/\[www\]/a\group = $FORM_socket_listen_group" /usr/local/php/etc/php-fpm.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_modified_to_socket" \
				detail="_NOTICE_php_modified_to_socket_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"socket_bind_address\":\"$FORM_socket_bind_address\", \
						\"socket_listen_owner\":\"$FORM_socket_listen_owner\", \
						\"socket_listen_group\":\"$FORM_socket_listen_group\", \
						\"socket_listen_mode\":\"$FORM_socket_listen_mode\" \
					}" >/dev/null 2>&1
(echo "Success save,you can install now" | main.sbin output_json 0) || exit 0
}

php_service()
{
if
[ "$FORM_php_enable" = "1" ]
then
echo "$OS" | grep -iq "centos" && chkconfig --add php-fpm && chkconfig php-fpm on >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f php-fpm defaults >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f php-fpm defaults >/dev/null 2>&1
service php-fpm start >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_service_enable" \
				detail="_NOTICE_php_service_enable" \
				uniqid="" \
				time="" \
				ergen="green" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn on" | main.sbin output_json 0) || exit 0
else
echo "$OS" | grep -iq "centos" && chkconfig --add php-fpm && chkconfig php-fpm off >/dev/null 2>&1
echo "$OS" | grep -iq "ubuntu" && update-rc.d -f php-fpm remove >/dev/null 2>&1
echo "$OS" | grep -iq "debian" && update-rc.d -f php-fpm remove >/dev/null 2>&1
service php-fpm stop >/dev/null 2>&1
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_service_disable" \
				detail="_NOTICE_php_service_disable" \
				uniqid="" \
				time="" \
				ergen="red" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1
(echo "Success turn off" | main.sbin output_json 0) || exit 0
fi
}
save_php_ini()
{
[ -n "$FORM_php_ini_str" ] || (echo "不能为空" | main.sbin output_json 1) || exit 1
echo "$FORM_php_ini_str" | grep -vE '^$|#|\[.*\]|=|^;' | grep -q [a-zA-Z0-9]
[ $? -ne 0 ] || (echo "配置文件内容有误" | main.sbin output_json 1) || exit 1
echo "$FORM_php_ini_str" > /usr/local/php/etc/php.ini
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_ini_modified" \
				detail="_NOTICE_php_ini_modified" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1
(echo "保存成功" | main.sbin output_json 0) || exit 0
}
save_php_fpm_conf()
{
[ -n "$FORM_php_fpm_conf_str" ] || (echo "不能为空" | main.sbin output_json 1) || exit 1
echo "$FORM_php_fpm_conf_str" | grep -vE '^$|#|\[.*\]|=|^;' | grep -q [a-zA-Z0-9]
[ $? -ne 0 ] || (echo "配置文件内容有误" | main.sbin output_json 1) || exit 1
echo "$FORM_php_fpm_conf_str" > /usr/local/php/etc/php-fpm.conf
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_fpm_conf_modified" \
				detail="_NOTICE_php_fpm_conf_modified" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" >/dev/null 2>&1

(echo "保存成功" | main.sbin output_json 0) || exit 0
}

change_mysqli_default_socket()
{
old_mysqli_default_socket=`grep -E "^mysqli.default_socket[ ]*=[ ]*" /usr/local/php/etc/php.ini | sed 's/^.*[ ]*=[ ]*//'`
echo "$FORM_mysqli_default_socket" | grep -q "^/" || (echo "mysqli_default_socket Error" | main.sbin output_json 1) || exit 1
sed -i '/^mysqli.default_socket[ ]*=[ ]*/d' /usr/local/php/etc/php.ini
sed -i "/\[MySQLi\]/a\mysqli.default_socket = $FORM_mysqli_default_socket" /usr/local/php/etc/php.ini
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_change_mysqli_default_socket" \
				detail="_NOTICE_php_change_mysqli_default_socket_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"mysqli_default_socket\":\"$FORM_mysqli_default_socket\", \
						\"old_mysqli_default_socket\":\"$old_mysqli_default_socket\" \
					}" >/dev/null 2>&1
(echo "mysqli_default_socket change Success" | main.sbin output_json 0) || exit 0
}
change_time_zone()
{
old_tz=`grep -E "^date\.timezone[ ]*=[ ]*" /usr/local/php/etc/php.ini | sed 's/^.*[ ]*=[ ]*//'`
sed -i '/^date\.timezone[ ]*=[ ]*/d' /usr/local/php/etc/php.ini
sed -i "/\[Date\]/a\date.timezone = $FORM_zonename" /usr/local/php/etc/php.ini
main.sbin notice option="add" \
				read="0" \
				desc="_NOTICE_php_change_time_zone" \
				detail="_NOTICE_php_change_time_zone_detail" \
				uniqid="" \
				time="" \
				ergen="yellow" \
				dest="php" \
				dest_type="app" \
					variable="{\
						\"tz\":\"$FORM_zonename\", \
						\"old_tz\":\"$old_tz\" \
					}" >/dev/null 2>&1
(echo "time_zone change Success" | main.sbin output_json 0) || exit 0
}
php_info()
{
(su - root -c '/usr/local/php/bin/php-cgi -q <<EOF
<?php phpinfo(); ?>
EOF'
exit)
}
. $DOCUMENT_ROOT/apps/sysinfo/sysinfo_lib.sh

