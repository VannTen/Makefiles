# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Srcs.mk                                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mgautier <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2016/12/19 07:58:53 by mgautier          #+#    #+#              #
#    Updated: 2016/12/19 09:12:55 by mgautier         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

TARGET := test
SRC := test.c

# Dependencies

LIBRARY := foo/test.a
OBJECTS :=
ELSE :=

# Sub directories

SUBDIRS := foo/
